#ifndef FILEIO_HPP
#define FILEIO_HPP

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QTemporaryDir>
#include <QUrl>
#include <QCryptographicHash>
#include <QImage>
#include <QUuid>
#include <QBuffer>
#include <QDebug>

class FileIO : public QObject
{
	Q_OBJECT

public:
	FileIO();

public slots:
	bool write(const QString& source, const QString& data);
	bool decodeAndWrite(const QString& source, const QString& data);
	bool setUserAvatar(const QString& user_key, const QString& data);
    bool hasAvatar(const QString& user_key);
	QString getAvatarPath(const QString& user_key=0);
    QUrl getAvatarUrl(const QString& user_key);
	QString getImagePath(const QString& name);
	QString decodeImage(const QString& data);
	QString getNewUserKey();
	QString getMd5Hash(const QString& data);

protected:
	QTemporaryDir m_tmpAvatarDir;
	QTemporaryDir m_tmpImageDir;
};

#endif // FILEIO_HPP
