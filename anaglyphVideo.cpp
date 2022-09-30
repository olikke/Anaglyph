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
    if (verticalShift<0) {
        left1=left1(cv::Rect(0,-verticalShift,left1.cols,left1.rows+verticalShift));
        right1=right1(cv::Rect(0,0,right1.cols,right1.rows+verticalShift));
    }
    if (!qFuzzyIsNull(leftAngle)) {
        cv::Mat rotate=cv::getRotationMatrix2D(cv::Point(left1.rows/2,left1.cols/2),leftAngle,1.);
        cv::warpAffine(left1,left1,rotate,cv::Size());
    }
    if (!qFuzzyIsNull(rightAngle)) {
        cv::Mat rotate=cv::getRotationMatrix2D(cv::Point(right1.rows/2,right1.cols/2),rightAngle,1.);
        cv::warpAffine(right1,right1,rotate,cv::Size());
    }

//    if (leftIncline>0) {
//            cv::Vector<cv::Point> src;
//            cv::Vector<cv::Point> dst;
//        cv::Mat homo=cv::findHomography(src,dst,CV_RANSAC,5.0);
//    }

    cv::Mat result=cv::Mat(right1.rows,right1.cols,CV_8UC4);

    cv::addWeighted(right1, 1, left1, 1, 0,result);

#ifdef TEST
    int kr=400;
    QRect leftQRect=QRect(kr*2,kr,left1.cols-kr*4,left1.rows-kr*2);
    cv::vector<cv::Point> vert;
    vert.push_back(cv::Point(leftQRect.topLeft().x(),leftQRect.topLeft().y()));
    vert.push_back(cv::Point(leftQRect.topRight().x(),leftQRect.topRight().y()));
    vert.push_back(cv::Point(leftQRect.bottomRight().x(),leftQRect.bottomRight().y()));
    vert.push_back(cv::Point(leftQRect.bottomLeft().x(),leftQRect.bottomLeft().y()));
    cv::polylines(result,vert,true,cv::Scalar(255,0,0));

    QTransform transform=QTransform();
    transform.translate(0,leftQRect.height());
    transform.rotate(45,Qt::XAxis);
 //   transform.translate(0,-leftQRect.height());

    QPolygon leftQPoli=transform.mapToPolygon(leftQRect);
    vert.clear();
    vert.push_back(cv::Point(leftQPoli.point(0).x(),leftQPoli.point(0).y()));
    vert.push_back(cv::Point(leftQPoli.point(1).x(),leftQPoli.point(1).y()));
    vert.push_back(cv::Point(leftQPoli.point(2).x(),leftQPoli.point(2).y()));
    vert.push_back(cv::Point(leftQPoli.point(3).x(),leftQPoli.point(3).y()));
    cv::polylines(result,vert,true,cv::Scalar(255,255,255));

//    transform.rotate(45,Qt::XAxis);
//    leftQPoli=transform.mapToPolygon(leftQRect);
//    vert.clear();
//    vert.push_back(cv::Point(leftQPoli.point(0).x(),leftQPoli.point(0).y()));
//    vert.push_back(cv::Point(leftQPoli.point(1).x(),leftQPoli.point(1).y()));
//    vert.push_back(cv::Point(leftQPoli.point(2).x(),leftQPoli.point(2).y()));
//    vert.push_back(cv::Point(leftQPoli.point(3).x(),leftQPoli.point(3).y()));
//    cv::polylines(result,vert,true,cv::Scalar(0,255,255));

#endif

    cv::cvtColor(result,result,CV_BGR2RGB);
    resultQIM=QImage((uchar*)result.data, result.cols, result.rows, result.step, QImage::Format_RGB888);
    emit newSample(resultQIM);
}


