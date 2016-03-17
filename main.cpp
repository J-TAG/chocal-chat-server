#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
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

	// Helper classes
	FileIO fileIO;
	Settings settings;

	QQmlApplicationEngine engine;
	engine.rootContext()->setContextProperty(QStringLiteral("fileio"), &fileIO);
	engine.rootContext()->setContextProperty(QStringLiteral("settings"), &settings);
	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

	return app.exec();
}
