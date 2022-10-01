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

    if (!qFuzzyIsNull(leftIncline)) {
        int width=left1.cols;
        int height=left1.rows;
        //найдем новые точки
        QTransform transform=QTransform();
        transform.translate(width/2,height/2);
        transform.rotate(leftIncline,Qt::XAxis);
        transform.translate(-width/2,-height/2);
        QRect srcRect=QRect(0,0,width,height);
        QPolygon polygon=transform.mapToPolygon(srcRect);;
        //а теперь построим
        std::vector<cv::Point2f> src;
        src.push_back(cv::Point2f(0,0));
        src.push_back(cv::Point2f(width,0));
        src.push_back(cv::Point2f(width,height));
        src.push_back(cv::Point2f(0,height));
        std::vector<cv::Point2f> dst;
        dst.push_back(cv::Point2f(polygon.point(0).x(),polygon.point(0).y()));
        dst.push_back(cv::Point2f(polygon.point(1).x(),polygon.point(1).y()));
        dst.push_back(cv::Point2f(polygon.point(2).x(),polygon.point(2).y()));
        dst.push_back(cv::Point2f(polygon.point(3).x(),polygon.point(3).y()));
        cv::Mat homo=cv::findHomography(src,dst,CV_RANSAC,5.);
        cv::warpPerspective(left1,left1,homo,cv::Size());
    }

    if (!qFuzzyIsNull(rightIncline)) {
        int width=right1.cols;
        int height=right1.rows;
        //найдем новые точки
        QTransform transform=QTransform();
        transform.translate(width/2,height/2);
        transform.rotate(rightIncline,Qt::XAxis);
        transform.translate(-width/2,-height/2);
        QRect srcRect=QRect(0,0,width,height);
        QPolygon polygon=transform.mapToPolygon(srcRect);;
        //а теперь построим
        std::vector<cv::Point2f> src;
        src.push_back(cv::Point2f(0,0));
        src.push_back(cv::Point2f(width,0));
        src.push_back(cv::Point2f(width,height));
        src.push_back(cv::Point2f(0,height));
        std::vector<cv::Point2f> dst;
        dst.push_back(cv::Point2f(polygon.point(0).x(),polygon.point(0).y()));
        dst.push_back(cv::Point2f(polygon.point(1).x(),polygon.point(1).y()));
        dst.push_back(cv::Point2f(polygon.point(2).x(),polygon.point(2).y()));
        dst.push_back(cv::Point2f(polygon.point(3).x(),polygon.point(3).y()));
        cv::Mat homo=cv::findHomography(src,dst,CV_RANSAC,5.);
        cv::warpPerspective(right1,right1,homo,cv::Size());
    }


    cv::Mat result=cv::Mat(right1.rows,right1.cols,CV_8UC4);

    cv::addWeighted(right1, 1, left1, 1, 0,result);

#ifdef TEST
    QRect leftQRect=QRect(400,400,400,300);
    cv::vector<cv::Point> vert;
    vert.push_back(cv::Point(leftQRect.topLeft().x(),leftQRect.topLeft().y()));
    vert.push_back(cv::Point(leftQRect.topRight().x(),leftQRect.topRight().y()));
    vert.push_back(cv::Point(leftQRect.bottomRight().x(),leftQRect.bottomRight().y()));
    vert.push_back(cv::Point(leftQRect.bottomLeft().x(),leftQRect.bottomLeft().y()));
    cv::polylines(result,vert,true,cv::Scalar(255,0,0));

    QTransform transform=QTransform();
    transform.translate(leftQRect.left()+leftQRect.width()/2,leftQRect.top()+leftQRect.height()/2);
    transform.rotate(45,Qt::XAxis);
    transform.translate(-(leftQRect.left()+leftQRect.width()/2),-(leftQRect.top()+leftQRect.height()/2));

    QPolygon leftQPoli=transform.mapToPolygon(leftQRect);
    vert.clear();
    vert.push_back(cv::Point(leftQPoli.point(0).x(),leftQPoli.point(0).y()));
    vert.push_back(cv::Point(leftQPoli.point(1).x(),leftQPoli.point(1).y()));
    vert.push_back(cv::Point(leftQPoli.point(2).x(),leftQPoli.point(2).y()));
    vert.push_back(cv::Point(leftQPoli.point(3).x(),leftQPoli.point(3).y()));
    cv::polylines(result,vert,true,cv::Scalar(255,255,255));
#endif

    cv::cvtColor(result,result,CV_BGR2RGB);
    resultQIM=QImage((uchar*)result.data, result.cols, result.rows, result.step, QImage::Format_RGB888);
    emit newSample(resultQIM);
}


