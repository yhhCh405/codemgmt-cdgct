import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_mgmt_cdgct/Models/movie.dart';
import 'package:code_mgmt_cdgct/Utils/extensions/context_ext.dart';
import 'package:code_mgmt_cdgct/ViewModels/movies_vm.dart';
import 'package:code_mgmt_cdgct/Views/movie_details_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _recommendVidsScrollController = ScrollController();
  final ScrollController _upcomingVidsScrollController = ScrollController();
  final MoviesVM _moviesVM = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    if (!_moviesVM.hasPopularMovie) {
      _moviesVM.getPopularVideos();
    }
    if (!_moviesVM.hasUpcomingMovie) {
      _moviesVM.getUpcomingMovies();
    }
    _recommendVidsScrollController.addListener(listenRecommendVidsScroll);
    _upcomingVidsScrollController.addListener(listenUpcomingVidsScroll);
  }

  void listenRecommendVidsScroll() {
    if (_recommendVidsScrollController.offset >=
            _recommendVidsScrollController.position.maxScrollExtent &&
        !_moviesVM.noMorePopularVideos.value) {
      _moviesVM.getPopularVideos();
    }
  }

  void listenUpcomingVidsScroll() {
    if (_upcomingVidsScrollController.offset >=
            _upcomingVidsScrollController.position.maxScrollExtent &&
        !_moviesVM.noMoreUpcomingVideos.value) {
      _moviesVM.getUpcomingMovies();
    }
  }

  Widget _headerWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "What are you looking for ? ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black45,
                ),
                suffixIcon: Icon(
                  Icons.sort,
                  color: Colors.black45,
                ),
                border: InputBorder.none,
                fillColor: Color(0xfff5f5f5),
                hintText: "Search for movies, events & more...",
                filled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendMovie(Movie movie) {
    return GestureDetector(
      onTap: () {
        context.next(MovieDetailsView(movie: movie));
      },
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            movie.posterPath != null
                ? CachedNetworkImage(
                    imageUrl: movie.posterPath!,
                    width: 120,
                    height: 160,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error),
                    ),
                  )
                : Container(
                    width: 120,
                    height: 160,
                    color: Colors.black,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                movie.title ?? "<Unknown>",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  color: movie.isFavourite ? Colors.red : Colors.black26,
                  onPressed: () {
                    movie.toggleFavourite();
                    if (mounted) setState(() {});
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(movie.voteAverage.toString())
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _upcomingMovie(Movie movie) {
    return GestureDetector(
      onTap: () {
        context.next(MovieDetailsView(
          movie: movie,
        ));
      },
      child: Container(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              movie.posterPath != null
                  ? CachedNetworkImage(
                      imageUrl: movie.posterPath!,
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 120,
                      color: Colors.black,
                    ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? "<Unknown>",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      movie.overview ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.favorite),
                          color:
                              movie.isFavourite ? Colors.red : Colors.black26,
                          onPressed: () {
                            movie.toggleFavourite();
                            if (mounted) setState(() {});
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(movie.voteAverage.toString()),
                        const SizedBox(
                          width: 20,
                        ),
                        const Icon(
                          Icons.comment_rounded,
                          color: Colors.amber,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(movie.voteCount.toString())
                      ],
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _upcomingVidsScrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: _headerWidget(),
            ),
            bottom: TabBar(
                isScrollable: true,
                controller: _tabController,
                labelColor: Colors.black,
                tabs: const [
                  Tab(text: "Movies"),
                  Tab(text: "Events"),
                  Tab(text: "Plays"),
                  Tab(text: "Sports"),
                  Tab(text: "Activities"),
                ]),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recommended",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: 250,
                      child: GetX<MoviesVM>(
                        builder: (vm) {
                          if (!vm.hasPopularMovie) {
                            if (vm.errorPopularVideoMsg.value != null) {
                              return Center(
                                child: Text(vm.errorPopularVideoMsg.value ??
                                    "Unknown Error"),
                              );
                            } else if (!vm.isNoPopularVideo.value) {
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            } else {
                              return const Center(
                                child: Text("No videos available"),
                              );
                            }
                          } else {
                            return ListView.separated(
                              controller: _recommendVidsScrollController,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                if (index ==
                                        vm.popularMovies.value!.length - 1 &&
                                    !vm.noMorePopularVideos.value) {
                                  return Row(
                                    children: [
                                      _recommendMovie(
                                          vm.popularMovies.value![index]),
                                      const Center(
                                        child: CupertinoActivityIndicator(),
                                      )
                                    ],
                                  );
                                }
                                return _recommendMovie(
                                    vm.popularMovies.value![index]);
                              },
                              separatorBuilder: (context, index) {
                                return Container(
                                  width: 15,
                                );
                              },
                              itemCount: vm.popularMovies.value!.length,
                            );
                          }
                        },
                      )),
                  const Text(
                    "Upcoming movies",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GetX<MoviesVM>(
                    builder: (vm) {
                      if (!vm.hasUpcomingMovie) {
                        if (vm.errorUpcomingVideoMsg.value != null) {
                          return Center(
                            child: Text(vm.errorUpcomingVideoMsg.value ??
                                "Unknown Error"),
                          );
                        } else if (!vm.isNoUpcomingVideo.value) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        } else {
                          return const Center(
                            child: Text("No videos available"),
                          );
                        }
                      } else {
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index == vm.upcomingMovies.value!.length - 1 &&
                                !vm.noMoreUpcomingVideos.value) {
                              return Column(
                                children: [
                                  _upcomingMovie(
                                      vm.upcomingMovies.value![index]),
                                  const Center(
                                    child: CupertinoActivityIndicator(),
                                  )
                                ],
                              );
                            }
                            return _upcomingMovie(
                                vm.upcomingMovies.value![index]);
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              height: 15,
                            );
                          },
                          itemCount: vm.upcomingMovies.value!.length,
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
