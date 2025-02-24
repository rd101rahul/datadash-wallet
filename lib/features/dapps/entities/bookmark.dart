class Bookmark {
  const Bookmark({
    required this.id,
    required this.title,
    required this.url,
    this.description,
    this.image,
    this.editable = true,
    this.occupyGrid = 1,
  });

  final int id;
  final String title;
  final String url;
  final String? description;
  final String? image;
  final bool editable;
  final int occupyGrid;

  static List<Bookmark> fixedBookmarks() {
    return [
      const Bookmark(
        id: 1,
        title: 'Bridge',
        description: '& Faucet',
        url: 'https://wannsee-bridge.mxc.com',
        image: 'assets/images/apps/bridge.png',
        editable: false,
        occupyGrid: 8,
      ),
      const Bookmark(
        id: 2,
        title: 'Stablecoin',
        description: 'world_un_depeggable',
        url: 'https://wannsee-xsd.mxc.com',
        image: 'assets/images/apps/stable_coin.png',
        editable: false,
        occupyGrid: 8,
      ),
      const Bookmark(
        id: 3,
        title: 'MNS',
        description: 'Own your .MXC domain',
        url: 'https://wannsee-mns.mxc.com',
        image: 'assets/images/apps/mns.png',
        editable: false,
        occupyGrid: 4,
      ),
      const Bookmark(
        id: 4,
        title: 'NFT',
        description: 'digitalize_your_assets',
        url: 'https://wannsee-nft.mxc.com',
        image: 'assets/images/apps/nft.png',
        editable: false,
        occupyGrid: 4,
      ),
    ];
  }
}
