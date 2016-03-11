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

QString Settings::getString(const QString &key, const QString &defaultValue)
{
	return this->settings.value(key, defaultValue).toString();
}
