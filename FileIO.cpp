#include "FileIO.hpp"

FileIO::FileIO()
{

}

bool FileIO::write(const QString& source, const QString& data)
{
	if (source.isEmpty())
		return false;

	QFile file(source);
	if (!file.open(QFile::WriteOnly | QFile::Truncate))
		return false;

	QTextStream out(&file);
	out << data;
	file.close();

	return true;
}

bool FileIO::decodeAndWrite(const QString& source, const QString& data)
{
	if (source.isEmpty())
		return false;

	QFile file(source);
	if (!file.open(QFile::WriteOnly | QFile::Truncate))
		return false;

	QByteArray bytes;
	bytes.append(data);
	file.write(QByteArray::fromBase64(bytes));
	file.close();

	return true;
}

bool FileIO::setUserAvatar(const QString &user_key, const QString &data)
{
	if(!m_tmpAvatarDir.isValid()) {
		return false;
	}

    QImage image;
    QByteArray dataBytes, resultBytes;
    QBuffer buffer(&resultBytes, this);
    QString avatar_path = this->getAvatarPath(user_key);

    dataBytes.append(data);
    // Resize image
    image.loadFromData(QByteArray::fromBase64(dataBytes));
    QImage(image.scaled(128, 128, Qt::KeepAspectRatioByExpanding, Qt::SmoothTransformation)).save(&buffer, "JPG");
    buffer.open(QIODevice::WriteOnly);

    return this->decodeAndWrite(avatar_path, resultBytes.toBase64());
}

bool FileIO::hasAvatar(const QString &user_key)
{
	return QFile::exists(this->getAvatarPath(user_key));
}

QString FileIO::getAvatarPath(const QString &user_key)
{
	if(!m_tmpAvatarDir.isValid()) {
		return 0;
	}

    if(user_key == 0) {
		return this->m_tmpAvatarDir.path();
	}

    // Note that FileIO::setUserAvatar() method will generate JPG files
    return m_tmpAvatarDir.path().append("/").append(user_key).append(".jpg");
}

QUrl FileIO::getAvatarUrl(const QString &user_key)
{
	return QUrl::fromLocalFile(this->getAvatarPath(user_key));
}

QString FileIO::getImagePath(const QString &name)
{
	if(!m_tmpImageDir.isValid()) {
		return 0;
	}

	return m_tmpImageDir.path().append("/").append(name);
}

QString FileIO::decodeImage(const QString &data)
{
	if(data.isEmpty()) {
		return "";
	}

	if(!m_tmpImageDir.isValid()) {
		return 0;
	}

	QString image_name(this->getMd5Hash(data));
	QString image_path(this->getImagePath(image_name));

	// Check to see if file exist already
	if(QFile::exists(image_path)) {
		return QUrl::fromLocalFile(image_path).toString();
	}

	// If file is not exist yet, create it
	if(this->decodeAndWrite(image_path, data)) {
		return QUrl::fromLocalFile(image_path).toString();
	}

	return 0;
}

QString FileIO::getNewUserKey()
{
	return QUuid::createUuid().toString();
}

QString FileIO::getMd5Hash(const QString &data)
{
	QCryptographicHash hash(QCryptographicHash::Md5);

	hash.addData(data.toUtf8());
	return hash.result().toHex();
}
