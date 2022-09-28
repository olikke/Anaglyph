#pragma once

#include <QObject>
#include <QFile>
#include <QImage>
#include <QDebug>

#include <gst/gst.h>
#include <gst/app/gstappsink.h>

class GrabbGst : public QObject
{
    Q_OBJECT
public:
    explicit GrabbGst(QObject *parent = nullptr);
    Q_INVOKABLE QStringList allDevice() {return allDevicesList;}
    Q_INVOKABLE void play(int numb);
    Q_INVOKABLE void rec(QString fileName);
    Q_INVOKABLE void stop();

signals:
    void newSample(QImage im);

private:
    QStringList allDevicesList;
    GstElement* pipeline=nullptr;
    QString deviceName;
    int dn;
};

