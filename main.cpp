#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QTranslator>
#include "FileIO.hpp"
#include "Settings.hpp"

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);

	// Application details
	QCoreApplication::setOrganizationName(QStringLiteral("Pure Soft"));
	QCoreApplication::setOrganizationDomain(QStringLiteral("puresoftware.org"));
	QCoreApplication::setApplicationName(QStringLiteral("Chocal Server"));
	// Set Version
	QCoreApplication::setApplicationVersion(VERSION);

	// Set Material style
	QQuickStyle::setStyle(QStringLiteral("Material"));

	// Helper classes
	FileIO fileIO;
	Settings settings;

	// Get application locale
	QLocale locale = settings.getLocale(QStringLiteral("locale"));
	QLocale::setDefault(locale);

	// Load translate texts for current language
	QTranslator translator;
	// Look up e.g. :/translations/translations/translate-fa.qm
	if (translator.load(locale, QLatin1String("translate"), QLatin1String("-"),
						QLatin1String(":/translations/translations"))){
		app.installTranslator(&translator);
	}

	QQmlApplicationEngine engine;
	engine.rootContext()->setContextProperty(QStringLiteral("fileio"), &fileIO);
	engine.rootContext()->setContextProperty(QStringLiteral("settings"), &settings);
	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

	return app.exec();
}
