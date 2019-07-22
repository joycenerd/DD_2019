#include <QtGui/QWidget>
#include <QPushButton>
#include <QPainter>
#include <QPaintEvent>
#include <QImage>
#include <QDebug>
#include <QElapsedTimer>
#include <QPixmap>

#include <QVector>
#include <QPoint>
#include <QMouseEvent>
#include <QPaintEvent>

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <time.h>
#include <math.h>

#define img_name "grayimg.jpg"

class MyWindow : public QWidget
{
    Q_OBJECT

public:
    explicit MyWindow(QWidget *parent = 0);

protected:
	void paintEvent(QPaintEvent*);

private slots:
    void ConfirmButton_clicked();
    void ClearButton_clicked();

private:  
    /* Handwriting */
    QVector<QPoint> stroke;
    QVector<QVector<QPoint> >lines;
    bool painting;

    /* Button */
    QPushButton *clr_btn;
    QPushButton *conf_btn;

    /* Mouse Event */
    void mousePressEvent(QMouseEvent* event);
    void mouseMoveEvent(QMouseEvent* event);
    void mouseReleaseEvent(QMouseEvent* event);
};
