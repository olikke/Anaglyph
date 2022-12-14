#include "imagepro.h"

void ImagePro::openFile(QString name, bool isLeft)
{
    if (name.contains("file:///"))
    {
        name.remove(0,7);
    }
    cv::Mat Image = cv::imread(name.toLatin1().constData());
    if (Image.empty())
    {
        qDebug()<<"Can't load image "<<name;
        return;
    }
    isLeft? left=Image.clone(): right=Image.clone();
    emit readyChanged();
}

void ImagePro::start()
{
    if (!getReady()) return;
    cv::Mat left1=cv::Mat(left.rows,left.cols,CV_8UC3);
    cv::Mat RGB[3];
    cv::split(left,RGB);
    RGB[0]=cv::Mat::zeros(left.rows,left.cols,CV_8UC1);
    RGB[1]=cv::Mat::zeros(left.rows,left.cols,CV_8UC1);
    merge(RGB,3,left1);;

    cv::Mat right1=cv::Mat(right.rows,right.cols,CV_8UC3);
    cv::split(right,RGB);
    RGB[2]=cv::Mat::zeros(right.rows,right.cols,CV_8UC1);
    merge(RGB,3,right1);

    cv::Mat result=cv::Mat(right.rows,right.cols,CV_8UC4);

    cv::addWeighted(right1, 1, left1, 1, 0,result);

    cv::cvtColor(result,result,CV_BGR2RGB);

    resultQIM=QImage((uchar*)result.data, result.cols, result.rows, result.step, QImage::Format_RGB888);
    emit newSample(resultQIM);
}

void ImagePro::loadDouble(QString filename)
{
    if (filename.contains("file:///"))
    {
        filename.remove(0,7);
    }
    cv::Mat Image = cv::imread(filename.toLatin1().constData());
    if (Image.empty())
    {
        qDebug()<<"Can't load image "<<filename;
        return;
    }
    cv::Mat leftD=Image(cv::Rect(0,0,Image.cols/2,Image.rows));
    cv::imwrite("/home/olikke/Work/leftD.bmp",leftD);

    cv::Mat rightD=Image(cv::Rect(Image.cols/2,0,Image.cols/2,Image.rows));
    cv::imwrite("/home/olikke/Work/rightD.bmp",rightD);
}
