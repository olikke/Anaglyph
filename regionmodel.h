#pragma once

#include <QObject>
#include <QAbstractListModel>
#include <QQmlApplicationEngine>
#include <QPointF>

class PointStateClass{
    Q_GADGET
public:
    enum PointState{
        Undefined,
        Remove,
        SomeElse
    };
    Q_ENUM(PointState)
    PointStateClass()=delete;
};
typedef PointStateClass::PointState PointState;

struct Point{
    QPointF point;
    int id;
    PointState state;
};

class RegionModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit RegionModel(QObject *parent = nullptr);

    enum {
        StateRole=Qt::UserRole+1,
        PosRole=Qt::UserRole+2,
        IDRole=Qt::UserRole+3
    };

    virtual int rowCount(const QModelIndex &parent) const;
    virtual QVariant data(const QModelIndex &index, int role) const;
    virtual QHash<int, QByteArray> roleNames() const;

signals:

public slots:

private:
    QList<Point> m_data;
};
