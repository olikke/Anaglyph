#include "writeopencv.h"

WriteOpenCV::~WriteOpenCV()
{
    stop();
}

void WriteOpenCV::start(QString name)
{
    if (name.contains("file:///"))
    {
        name.remove(0,7);
    }
    writer=new cv::VideoWriter(name.toLatin1().constData(),CV_FOURCC('M','J','P','G'), 25, cv::Size(width,height));
    isRecord=true;
    emit isRecordChanged();
    emit startRecord(true);
}

void WriteOpenCV::stop()
{
    emit startRecord(false);
    isRecord=false;
    emit isRecordChanged();

}

void WriteOpenCV::newFrame(cv::Mat frame)
{
    if (!writer) return;
    cv::Mat newFrame=frame.clone();
    if (frame.rows!=height | frame.cols!=width)
        cv::resize(newFrame,newFrame,cv::Size(width,height));
    writer->write(newFrame);
}
