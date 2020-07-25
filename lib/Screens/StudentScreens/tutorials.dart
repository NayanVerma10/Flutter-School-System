import 'package:Schools/constants.dart';
import 'package:Schools/widgets/swipedetector.dart';
import 'package:Schools/Screens/PDFOpener.dart';
import 'package:Schools/models/E-Book.dart';
import 'package:flutter/material.dart';
import 'package:division/division.dart';

const double _imageHeight = 230;
const double _buttonHeight = 40;

class EBookInfo extends StatefulWidget {
  final EBook eBook;

  EBookInfo({@required this.eBook, Key key}) : super(key: key);

  @override
  _EBookInfoState createState() => _EBookInfoState();
}

class _EBookInfoState extends State<EBookInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SwipeDetector(
        onSwipeDown: () {
          kbackBtn(context);
        },
        onSwipeRight: () {
          kbackBtn(context);
        },
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.red,
                    Colors.blue,
                  ],
                  stops: [0.0, 1.0],
                ),
                image: DecorationImage(
                  image: NetworkImage(widget.eBook.imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Theme.of(context).canvasColor.withOpacity(0.15),
                      BlendMode.dstATop),
                ),
              ),
            ),
            Positioned(
              left: 8,
              right: 5,
              top: MediaQuery.of(context).size.height * 0.09,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: widget.eBook.bookId + 'image',
                    transitionOnUserGestures: true,
                    child: Container(
                      height: _imageHeight,
                      child: AspectRatio(
                        aspectRatio: 9 / 13,
                        child: Card(
                          elevation: 10,
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.eBook.imageUrl),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // SizedBox(height: 20,),
                        Hero(
                          tag: widget.eBook.bookId + widget.eBook.bookName,
                          transitionOnUserGestures: true,
                          child: Text(
                            widget.eBook.bookName,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: ktitleStyle.copyWith(
                                fontSize: 20, fontWeight: FontWeight.w900),
                          ),
                        ),
                        Text(
                          'By',
                          textAlign: TextAlign.center,
                          style: ktitleStyle.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Hero(
                          tag: widget.eBook.bookId + widget.eBook.bookAuthor,
                          transitionOnUserGestures: true,
                          child: Text(
                            widget.eBook.bookAuthor,
                            textAlign: TextAlign.center,
                            style: ksubtitleStyle.copyWith(fontSize: 18),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'for:',
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: ksubtitleStyle.copyWith(fontSize: 18),
                            ),
                            Expanded(
                              child: Text(
                                widget.eBook.bookIsForStandard == 'N.A'
                                    ? ' ' + widget.eBook.bookIsForStandard
                                    : ' ' +
                                    widget.eBook.bookIsForStandard +
                                    'th Standard',
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: ksubtitleStyle.copyWith(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              left: 10,
              top:
              _imageHeight + MediaQuery.of(context).size.height * 0.08 + 15,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: _ReusableEbookBtn(
                      onTap: () => kopenPage(
                        context,
                        PDFOpener(
                          title: widget.eBook.bookName,
                          url: widget.eBook.pdfUrl,
                        ),
                      ),
                      title: 'Read',
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: _ReusableEbookBtn(
                      onTap: () {},
                      title: 'Add to Favourites',
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: 10,
              left: 10,
              top: _imageHeight +
                  _buttonHeight +
                  MediaQuery.of(context).size.height * 0.08 +
                  20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Description: ',
                    style: ktitleStyle.copyWith(fontSize: 20),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.eBook.description,
                      style: ksubtitleStyle,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ReusableEbookBtn extends StatelessWidget {
  final String title;
  final Function onTap;
  const _ReusableEbookBtn({
    @required this.onTap,
    @required this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: ParentStyle()
      // ..alignment.center()
        ..elevation(5)
        ..background.color(Colors.blue[300])
        ..height(_buttonHeight)
        ..ripple(true)
        ..borderRadius(all: 8),
      gesture: Gestures()
        ..onTap(() => onTap()),
      // ..onLongPress(() => onTap)
      // ..onDoubleTap(() => onTap())
      // ..onTapCancel(() => onTap()),
      child: Center(
        child: Text(
          title,
          style: ktitleStyle.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
