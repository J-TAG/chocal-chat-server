#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "FileIO.hpp"

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);
	FileIO fileIO;

	QQmlApplicationEngine engine;
	engine.rootContext()->setContextProperty("fileio", &fileIO);
	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

	return app.exec();
}
