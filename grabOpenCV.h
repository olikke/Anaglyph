#pragma once

#include <QObject>
#include <QDebug>
#include <opencv2/opencv.hpp>


class GrabOpenCV : public QObject
{
    Q_OBJECT
public:
    explicit GrabOpenCV(QObject *parent = nullptr): QObject(parent) {}
    ~GrabOpenCV();
    Q_INVOKABLE void start(int numb);
    Q_INVOKABLE void photoName(QString name);
    Q_INVOKABLE void stop();
signals:
    void newSample(cv::Mat mat);

public slots:
    void execute();

private:
    cv::VideoCapture* cap;
    bool video=false;
    cv::Mat frame;
};
