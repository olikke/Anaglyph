#include "grabOpenCV.h"


GrabOpenCV::GrabOpenCV(int number, QObject *parent) : QObject(parent)
{
    number==1?
        testName="/home/olikke/Work/GitWork/Anaglyph/Image/left.bmp":
        testName="/home/olikke/Work/GitWork/Anaglyph/Image/right.bmp";
}

GrabOpenCV::~GrabOpenCV()
{
    cap.release();
}

void GrabOpenCV::start(int numb)
{
    if (numb<0) {
        test=true;
        return;
    }
    test=false;
    cap=cv::VideoCapture(numb);
    cap.set(CV_CAP_PROP_FRAME_WIDTH,1920);
    cap.set(CV_CAP_PROP_FRAME_HEIGHT,1080);
}

void GrabOpenCV::execute()
{
    if (test) {
        cv::Mat fr=cv::imread(testName.toLatin1().constData());
        if (fr.empty()) return;
        qDebug()<<"execute";
        emit newSample(fr);
        return;
    }
    cv::Mat frame;
    cap>>frame;
    if (frame.empty()) return;
    emit newSample(frame);
}
