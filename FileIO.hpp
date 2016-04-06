#ifndef FILEIO_HPP
#define FILEIO_HPP

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QTemporaryDir>
#include <QUrl>

class FileIO : public QObject
{
	Q_OBJECT

public:
	FileIO();

public slots:
	bool write(const QString& source, const QString& data);
	bool decodeAndWrite(const QString& source, const QString& data);
	bool setUserAvatar(const QString& name, const QString& data);
	bool hasAvatar(const QString& name);
	QString getAvatarPath(const QString& name=0);
	QUrl getAvatarUrl(const QString& name);
	QString getImagePath(const QString& name);
	QString decodeImage(const QString& data);
	QString getNewUserKey();
	QString getMd5Hash(const QString& data);

protected:
	QTemporaryDir m_tmpAvatarDir;
	QTemporaryDir m_tmpImageDir;
};

#endif // FILEIO_HPP
