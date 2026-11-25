import 'package:flutter/material.dart';
import 'rider_detail_page.dart';
import 'rider_model.dart';

class RiderCard extends StatefulWidget {
  final Rider rider;

  const RiderCard(this.rider, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RiderCardState createState() => _RiderCardState();
}

class _RiderCardState extends State<RiderCard> {
  String? renderUrl;
  bool loading = true;

  Rider get rider => widget.rider;
  Color get teamColor => rider.teamColor ?? const Color(0xFFE10600);

  @override
  void initState() {
    super.initState();
    renderRiderPic();
  }

  // Demana les dades a l'API i, quan arriben, torna a pintar la targeta.
  void renderRiderPic() async {
    await rider.getRiderData();
    if (mounted) {
      setState(() {
        renderUrl = rider.imageUrl;
        loading = false;
      });
    }
  }

  // Foto rodona: la imatge és del cos sencer amb molt de marge,
  // així que l'ampliem (Transform.scale) per veure només la cara i el tors.
  Widget get riderImage {
    var riderAvatar = Hero(
      tag: rider,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: teamColor,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: ClipOval(
          child: Transform.scale(
            scale: 2.6,
            alignment: const Alignment(0, -0.95),
            child: Image(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              image: rider.photo,
              // Mentre es descarrega la foto (són PNG grans) mostrem un indicador de càrrega.
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : const Center(child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1, color: Colors.white))),
            ),
          ),
        ),
      ),
    );

    var placeholder = Container(
      width: 100.0,
      height: 100.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.black87, Color(0xFFE10600)],
        ),
      ),
      alignment: Alignment.center,
      child: loading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('?', style: TextStyle(fontSize: 40, color: Colors.white)),
    );

    return AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: renderUrl == null ? placeholder : riderAvatar,
      crossFadeState: renderUrl == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 1000),
    );
  }

  Widget get riderCard {
    return Positioned(
      left: 50.0,
      right: 0.0,
      child: SizedBox(
        height: 115,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: const Color(0xFF1E1E1E),
          child: Stack(
            children: [
              // Número del pilot gran i transparent al fons de la targeta.
              Positioned(
                right: 10,
                top: -12,
                child: Text(
                  rider.number != null ? '${rider.number}' : '',
                  style: TextStyle(
                    fontSize: 90,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: teamColor.withValues(alpha: 0.35),
                  ),
                ),
              ),
              // Franja amb el color de l'equip.
              Positioned(left: 0, top: 0, bottom: 0, child: Container(width: 6, color: teamColor)),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 64, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '${rider.flag} ${rider.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      rider.team ?? (loading ? 'Carregant...' : 'No trobat a l\'API'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.star, color: Color(0xFFFFC107), size: 20),
                        Text(' ${rider.rating}/10', style: const TextStyle(color: Colors.white, fontSize: 14.0)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // En tornar de la pàgina de detall refresquem la targeta (pot haver canviat la puntuació).
  void showRiderDetailPage() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RiderDetailPage(rider);
    }));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: rider.found ? () => showRiderDetailPage() : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SizedBox(
          height: 115.0,
          child: Stack(
            children: <Widget>[
              riderCard,
              Positioned(top: 7.5, child: riderImage),
            ],
          ),
        ),
      ),
    );
  }
}
