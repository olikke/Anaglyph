#include "grabOpenCV.h"


GrabOpenCV::GrabOpenCV(int number, QObject *parent) : QObject(parent)
{
    numb=number;
}

GrabOpenCV::~GrabOpenCV()
{
        cap.release();
}

void GrabOpenCV::start(int numb)
{
    if (numb<0) return;
    cap=cv::VideoCapture(numb);
    cap.set(CV_CAP_PROP_FRAME_WIDTH,1920);
    cap.set(CV_CAP_PROP_FRAME_HEIGHT,1080);
}

void GrabOpenCV::execute()
{
    cv::Mat frame;
    cap>>frame;
    if (frame.empty()) return;
  //  frame.resize(cv::Size(frame.rows/2,frame.cols/2))
    emit newSample(frame);
}
