#pragma once

#include <QObject>
#include <QDebug>
#include <QImage>
#include <opencv2/opencv.hpp>

class ImagePro : public QObject
{
    Q_OBJECT
public:
    explicit ImagePro(QObject *parent = nullptr): QObject(parent) {    emit readyChanged();}
    Q_INVOKABLE void openFile(QString name, bool isLeft);

    Q_PROPERTY(bool ready READ getReady NOTIFY readyChanged)
    bool getReady() {return (!left.empty() & !right.empty());}

    Q_INVOKABLE void start();

    Q_INVOKABLE void loadDouble(QString filename);

signals:
    void readyChanged();
    void newSample(QImage im);

private:
    cv::Mat left;
    cv::Mat right;
    QImage resultQIM;

};

