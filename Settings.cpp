#include "Settings.hpp"

Settings::Settings(QObject *parent) : QObject(parent)
{

}

void Settings::setValue(const QString &key, const QString &value)
{
	this->settings.setValue(key, value);
}

int Settings::getInt(const QString &key, int defaultValue)
{
	return this->settings.value(key, defaultValue).toInt();
}

bool Settings::getBool(const QString &key, bool defaultValue)
{
	return this->settings.value(key, defaultValue).toBool();
}

QLocale Settings::getLocale(const QString &key, QString defaultValue)
{
	QString str_locale(this->settings.value(key, defaultValue).toString());
	return QLocale(str_locale);
}

QString Settings::getString(const QString &key, const QString &defaultValue)
{
	return this->settings.value(key, defaultValue).toString();
}
