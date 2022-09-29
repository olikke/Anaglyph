#include "anaglyphVideo.h"

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

    if (horizontShift>0) {
        left1=left1(cv::Rect(0,0,left1.cols-horizontShift,left1.rows));
        right1=right1(cv::Rect(horizontShift,0,right1.cols-horizontShift,right1.rows));
    }
    if (horizontShift<0) {
        left1=left1(cv::Rect(-horizontShift,0,left1.cols+horizontShift,left1.rows));
        right1=right1(cv::Rect(0,0,right1.cols+horizontShift,right1.rows));
    }
    if (verticalShift>0) {
        left1=left1(cv::Rect(0,0,left1.cols,left1.rows-verticalShift));
        right1=right1(cv::Rect(0,verticalShift,right1.cols,right1.rows-verticalShift));

    }

#ifdef TEST
    cv::Rect leftRect=cv::Rect(200,200,left1.cols/2-205,left1.rows-400);
    cv::rectangle(left1,leftRect,cv::Scalar(0, 0, 255),4);
    cv::rectangle(right1,cv::Point(right1.cols/2+5,200),cv::Point(right1.cols-200,right1.rows-200),cv::Scalar(255, 0255, 0),4);
#endif

    if (leftIncline>0) {
            cv::Vector<cv::Point> src;
            cv::Vector<cv::Point> dst;
        cv::Mat homo=cv::findHomography(src,dst,CV_RANSAC,5.0);
    }

    cv::Mat result=cv::Mat(right1.rows,right1.cols,CV_8UC4);

    cv::addWeighted(right1, 1, left1, 1, 0,result);

    cv::cvtColor(result,result,CV_BGR2RGB);
    resultQIM=QImage((uchar*)result.data, result.cols, result.rows, result.step, QImage::Format_RGB888);
    emit newSample(resultQIM);
}
