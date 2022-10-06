#pragma once
#include <QObject>
#include <QImage>
#include <opencv2/opencv.hpp>
#include <QtConcurrent>
#include <QTransform>

const double PRECISION=0.1;

class AnaglyphVideo : public QObject
{
    Q_OBJECT
public:
    explicit AnaglyphVideo(QObject *parent = nullptr): QObject(parent) {}

    Q_INVOKABLE double getPrecision() {return PRECISION;}

    Q_INVOKABLE void setHorizontShift(int value) {horizontShift=value;}
    Q_INVOKABLE void setVerticalShift(int value) {verticalShift=value;}
    Q_INVOKABLE void setLeftAngle(int value) {leftAngle=value*PRECISION;}
    Q_INVOKABLE void setRightAngle(int value) {rightAngle=value*PRECISION;}
    Q_INVOKABLE void setLeftIncline(int value) {leftIncline=value*PRECISION;}
    Q_INVOKABLE void setRightIncline(int value) {rightIncline=value*PRECISION;}
    Q_INVOKABLE void setLeftTurn(int value) {leftTurn=value*PRECISION;}
    Q_INVOKABLE void setRightTurn(int value) {rightTurn=value*PRECISION;}

    Q_INVOKABLE void setOnlyOne(bool vOnlyOne, bool vLeft) {onlyOne=vOnlyOne; isLeft=vLeft;}
    Q_INVOKABLE void setBoth() {onlyOne=false;}

    Q_INVOKABLE void saveScreen(QString name);

    Q_INVOKABLE void setText(QString value, int dist) {text=value; textDist=dist;}

signals:
    void newSample(QImage im);
    void newFrame(cv::Mat im);
public slots:
    void leftSample(cv::Mat im);
    void rightSample(cv::Mat im);
    void startRecord(bool start) {startRec=start;}
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
    void calcTransform(cv::Mat &image,double angle,Qt::Axis axis);
    bool onlyOne=false;
    bool isLeft=false;
    QString fileName="";
    bool startRec=false;
    QString text="";
    int textDist=0;
};

