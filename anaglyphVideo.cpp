#include "anaglyphVideo.h"

AnaglyphVideo::AnaglyphVideo(QObject *parent) : QObject(parent)
{
}

void AnaglyphVideo::leftSample(cv::Mat im)
{
    left=im.clone();
    leftNew=true;
    timeOut();
}

void AnaglyphVideo::rightSample(cv::Mat im)
{
    right=im.clone();
    rightNew=true;
    timeOut();
}

void AnaglyphVideo::timeOut()
{
    if (!leftNew | !rightNew) return;
    leftNew=false;
    rightNew=false;
    cv::Mat left1=cv::Mat(left.rows,left.cols,CV_8UC3);
    cv::Mat RGB[3];
    cv::split(left,RGB);
    RGB[0]=cv::Mat::zeros(left.rows,left.cols,CV_8UC1);
    RGB[1]=cv::Mat::zeros(left.rows,left.cols,CV_8UC1);
    merge(RGB,3,left1);

    cv::Mat right1=cv::Mat(right.rows,right.cols,CV_8UC3);
    cv::split(right,RGB);
    RGB[2]=cv::Mat::zeros(right.rows,right.cols,CV_8UC1);
    merge(RGB,3,right1);

    if (shiftLeft>0) {
        left1=left1(cv::Rect(0,0,left1.cols-shiftLeft,left1.rows));
        right1=right1(cv::Rect(shiftLeft,0,right1.cols-shiftLeft,right1.rows));
    }

    if (shiftLeft<0) {
        left1=left1(cv::Rect(-shiftLeft,0,left1.cols+shiftLeft,left1.rows));
        right1=right1(cv::Rect(0,0,right1.cols+shiftLeft,right1.rows));
    }

    if (!qFuzzyIsNull(angle)) {
        cv::Point center=cv::Point(left1.cols/2,left1.rows/2);
        cv::Mat rotate=cv::getRotationMatrix2D(center,angle,1.);
        cv::warpAffine(left1,left1,rotate,cv::Size());
        rotate=cv::getRotationMatrix2D(center,-angle,1.);
        cv::warpAffine(right1,right1,rotate,cv::Size());
    }






    cv::Mat result=cv::Mat(right1.rows,right1.cols,CV_8UC4);

   cv::addWeighted(right1, 1, left1, 1, 0,result);

   cv::cvtColor(result,result,CV_BGR2RGB);

   resultQIM=QImage((uchar*)result.data, result.cols, result.rows, result.step, QImage::Format_RGB888);

   emit newSample(resultQIM);


}
