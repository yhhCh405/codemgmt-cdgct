import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_mgmt_cdgct/Models/movie.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class MovieDetailsView extends StatefulWidget {
  final Movie movie;
  const MovieDetailsView({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsViewState createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                widget.movie.fullResPosterPath != null
                    ? CachedNetworkImage(
                        imageUrl: widget.movie.fullResPosterPath!,
                        width: context.width,
                        height: 200,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
                      )
                    : Container(
                        width: context.width,
                        height: 200,
                        color: Colors.black,
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.movie.title ??
                                    widget.movie.originalTitle ??
                                    "Unknown Title",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(widget.movie.releaseDate ?? ""),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("1 hr 55 min | Drama, fantasy")
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.favorite),
                                    color: widget.movie.isFavourite
                                        ? Colors.red
                                        : Colors.black26,
                                    onPressed: () {
                                      widget.movie.toggleFavourite();
                                      if (mounted) setState(() {});
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(widget.movie.voteAverage.toString())
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "${widget.movie.voteCount?.toInt() ?? 0} votes"),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text((widget.movie.originalLanguage ?? "") +
                                      " "),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    color: Colors.black12,
                                    child: const Text(
                                      "2D",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Movie description",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(widget.movie.overview ?? ""),
                      const SizedBox(
                        height: 10,
                      ),
                      // const Text(
                      //   "Cast",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold, fontSize: 16),
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // SizedBox(
                      //   height: 250,
                      //   child: ListView.separated(
                      //     shrinkWrap: true,
                      //     scrollDirection: Axis.horizontal,
                      //     itemBuilder: (context, index) {
                      //       return Container(
                      //         width: 100,
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Container(
                      //               width: 100,
                      //               height: 120,
                      //               color: Colors.black,
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.symmetric(
                      //                   vertical: 10),
                      //               child: Text(
                      //                 "MOvie name" * 5,
                      //                 maxLines: 2,
                      //                 overflow: TextOverflow.ellipsis,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //     separatorBuilder: (context, index) {
                      //       return Container(
                      //         width: 15,
                      //       );
                      //     },
                      //     itemCount: 10,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text(
                "Book Tickets",
                style: const TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
