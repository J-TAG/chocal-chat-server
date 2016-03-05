#ifndef FILEIO_HPP
#define FILEIO_HPP

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QTemporaryDir>

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

protected:
	QTemporaryDir m_tmpAvatarDir;
};

#endif // FILEIO_HPP
