#pragma once
#include <QObject>
#include <QImage>
#include <opencv2/opencv.hpp>
#include <QtConcurrent>
#include <QTransform>

//#define TEST

class AnaglyphVideo : public QObject
{
    Q_OBJECT
public:
    explicit AnaglyphVideo(QObject *parent = nullptr): QObject(parent) {}

    Q_INVOKABLE void setHorizontShift(int value) {horizontShift=value;}
    Q_INVOKABLE void setVerticalShift(int value) {verticalShift=value;}
    Q_INVOKABLE void setLeftAngle(double value) {leftAngle=value;}
    Q_INVOKABLE void setRightAngle(double value) {rightAngle=value;}



    Q_INVOKABLE void setLeftIncline(double value) {leftIncline=value/10;}
    Q_INVOKABLE void setRightIncline(double value) {rightIncline=value/10;}
    Q_INVOKABLE void setLeftTurn(double value) {leftTurn=value;}
    Q_INVOKABLE void setRightTurn(double value) {rightTurn=value;}

signals:
    void newSample(QImage im);
public slots:
    void leftSample(cv::Mat im);
    void rightSample(cv::Mat im);
private:
    cv::Mat left;
    cv::Mat right;
    QImage resultQIM;
    bool leftNew=false;
    bool rightNew=false;
    void timeOut();
    int horizontShift=0;
    int verticalShift=0;
    double leftAngle=0.;
    double rightAngle=0.;
    double leftIncline=0.;
    double rightIncline=0.;
    double leftTurn=0.;
    double rightTurn=0.;
    cv::Rect calcIncline(const cv::Rect &before);
};

