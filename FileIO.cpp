#include "FileIO.hpp"
#include <QDebug>

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

	QString avatar_path = this->getAvatarPath(user_key);

	return this->decodeAndWrite(avatar_path, data);
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

	return m_tmpAvatarDir.path().append("/").append(user_key).append(".png");
}
