#include "grabOpenCV.h"

GrabOpenCV::~GrabOpenCV()
{
   stop();
}

void GrabOpenCV::start(int numb)
{
    if (numb<0)  return;
    video=true;
    stop();
    cap=new cv::VideoCapture(numb);
    cap->set(CV_CAP_PROP_FRAME_WIDTH,1920);
    cap->set(CV_CAP_PROP_FRAME_HEIGHT,1080);
}

void GrabOpenCV::photoName(QString name)
{
    if (name.contains("file:///"))
    {
        name.remove(0,7);
    }
    frame = cv::imread(name.toLatin1().constData());
    if (frame.empty())
    {
        qDebug()<<"Can't load image "<<name;
        return;
    }
}

void GrabOpenCV::stop()
{
    if (cap) {
        cap->release();
        cap=nullptr;
    }
}

void GrabOpenCV::execute()
{
    if (video) *cap>>frame;
    if (frame.empty()) return;
    emit newSample(frame);
}
