#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include "imageprovider.h"
#include "grabbgst.h"
#include "imagepro.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("Some organization");

    QApplication app(argc, argv);

    QQmlApplicationEngine * engine=new QQmlApplicationEngine(&app);
    QQmlContext *context = engine->rootContext();

    GrabbGst* grabber1=new GrabbGst(&app);
    context->setContextProperty("grabber1",grabber1);
    ImageProvider* provider1=new ImageProvider(&app,QSize(1920,1080));
    context->setContextProperty("provider1",provider1);
    engine->addImageProvider("mlive1",provider1);
    QObject::connect(grabber1,&GrabbGst::newSample,provider1,&ImageProvider::updateImage);

    GrabbGst* grabber2=new GrabbGst(&app);
    context->setContextProperty("grabber2",grabber2);
    ImageProvider* provider2=new ImageProvider(&app,QSize(1920,1080));
    context->setContextProperty("provider2",provider2);
    engine->addImageProvider("mlive2",provider2);
    QObject::connect(grabber2,&GrabbGst::newSample,provider2,&ImageProvider::updateImage);

    ImagePro* imagePro=new ImagePro(&app);
    context->setContextProperty("imagePro",imagePro);
    ImageProvider* stereoProvider=new ImageProvider(&app,QSize(1,1));
    context->setContextProperty("stereoProvider",stereoProvider);
    engine->addImageProvider("mlive3",stereoProvider);
    QObject::connect(imagePro,&ImagePro::newSample,stereoProvider,&ImageProvider::updateImage);


    engine->load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine->rootObjects().isEmpty())  return -1;


    return app.exec();
}



