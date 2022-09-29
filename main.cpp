#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QTimer>
#include <QIcon>
#include "imageprovider.h"
#include "imagepro.h"
#include "grabOpenCV.h"
#include "anaglyphVideo.h"
#include "camfinder.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("Some organization");

    QApplication app(argc, argv);

    app.setWindowIcon(QIcon(":/icon/glass.png"));

    QQmlApplicationEngine * engine=new QQmlApplicationEngine(&app);
    QQmlContext *context = engine->rootContext();

    CamFinder* camFinder=new CamFinder(&app);
    context->setContextProperty("camFinder",camFinder);

    QTimer* timer=new QTimer(&app);
    timer->setInterval(80);
    context->setContextProperty("timer",timer);

    GrabOpenCV* left=new GrabOpenCV(1,&app);
    context->setContextProperty("leftGrab",left);
    QObject::connect(timer,&QTimer::timeout,left,&GrabOpenCV::execute);

    GrabOpenCV* right=new GrabOpenCV(2,&app);
    context->setContextProperty("rightGrab",right);
    QObject::connect(timer,&QTimer::timeout,right,&GrabOpenCV::execute);

    AnaglyphVideo* anaglyphVideo=new AnaglyphVideo(&app);
    QObject::connect(left,&GrabOpenCV::newSample,anaglyphVideo,&AnaglyphVideo::leftSample);
    QObject::connect(right,&GrabOpenCV::newSample,anaglyphVideo,&AnaglyphVideo::rightSample);
    context->setContextProperty("anaglyph",anaglyphVideo);

    ImageProvider* provider=new ImageProvider(&app,QSize(1920,1080));
    context->setContextProperty("videoProvider",provider);
    engine->addImageProvider("mlive",provider);
    QObject::connect(anaglyphVideo,&AnaglyphVideo::newSample,provider,&ImageProvider::updateImage);

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



