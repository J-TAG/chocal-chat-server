#ifndef SETTINGS_HPP
#define SETTINGS_HPP

#include <QSettings>
#include <QLocale>

class Settings : public QObject
{
	Q_OBJECT
public:
	explicit Settings(QObject *parent = 0);

signals:

public slots:
	void setValue(const QString& key, const QString& value);
	QString getString(const QString& key, const QString& defaultValue=0);
	int getInt(const QString& key, int defaultValue=0);
	bool getBool(const QString& key, bool defaultValue=false);
	QLocale getLocale(const QString& key, QString defaultValue=QStringLiteral("en_US"));

protected:
	QSettings settings;
};

#endif // SETTINGS_HPP
