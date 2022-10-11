#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QTimer>
#include <QIcon>
#include <QScreen>
#include "imageprovider.h"
#include "imagepro.h"
#include "grabOpenCV.h"
#include "anaglyphVideo.h"
#include "camfinder.h"
#include "writeopencv.h"

int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_DisableHighDpiScaling);

     QApplication app(argc, argv);

     qDebug()<< "OpenCV version : " << CV_VERSION << endl;
     qDebug()<< "Major version : " << CV_MAJOR_VERSION << endl;
     qDebug()<< "Minor version : " << CV_MINOR_VERSION << endl;
     qDebug() << "Subminor version : " << CV_SUBMINOR_VERSION << endl;

     auto screen = QGuiApplication::primaryScreen();
     QRect currScreen = screen->geometry();
     const qreal dpi = screen->logicalDotsPerInch();

     const double refDpi = 96;
     const double refHeight = 1440;
     const double refWidth =2560;

     qreal m_extentsRatio = qMin( currScreen.height() / refHeight, currScreen.width() / refWidth );
     qreal m_fontsRatio = qMin( currScreen.height() * refDpi / ( dpi * refHeight ), currScreen.width() * refDpi / ( dpi * refWidth ) );

    app.setWindowIcon(QIcon(":/icon/glass.png"));

    QQmlApplicationEngine * engine=new QQmlApplicationEngine(&app);
    QQmlContext *context = engine->rootContext();

    context->setContextProperty("ratio",m_extentsRatio);
    context->setContextProperty("fontsRatio",m_fontsRatio);

    CamFinder* camFinder=new CamFinder(&app);
    context->setContextProperty("camFinder",camFinder);

    QTimer* timer=new QTimer(&app);
    timer->setInterval(40);
    context->setContextProperty("timer",timer);

    GrabOpenCV* left=new GrabOpenCV(&app);
    context->setContextProperty("leftGrab",left);
    QObject::connect(timer,&QTimer::timeout,left,&GrabOpenCV::execute);

    GrabOpenCV* right=new GrabOpenCV(&app);
    context->setContextProperty("rightGrab",right);
    QObject::connect(timer,&QTimer::timeout,right,&GrabOpenCV::execute);

    WriteOpenCV* writeOpenCV=new WriteOpenCV(&app);
    context->setContextProperty("writer",writeOpenCV);

    AnaglyphVideo* anaglyphVideo=new AnaglyphVideo(&app);
    QObject::connect(left,&GrabOpenCV::newSample,anaglyphVideo,&AnaglyphVideo::leftSample);
    QObject::connect(right,&GrabOpenCV::newSample,anaglyphVideo,&AnaglyphVideo::rightSample);
    context->setContextProperty("anaglyph",anaglyphVideo);

    QObject::connect(writeOpenCV,&WriteOpenCV::startRecord,anaglyphVideo,&AnaglyphVideo::startRecord);
    QObject::connect(anaglyphVideo,&AnaglyphVideo::newFrame,writeOpenCV,&WriteOpenCV::newFrame);

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



