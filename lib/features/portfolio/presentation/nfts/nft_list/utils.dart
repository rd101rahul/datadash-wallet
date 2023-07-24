import 'package:datadashwallet/features/portfolio/presentation/nfts/nft_list/widgets/nft_collection_expandable_item.dart';
import 'package:mxc_logic/mxc_logic.dart';

class NFTListUtils {
  static List<NFTCollectionExpandableItem> generateNFTList(
      List<NFTCollection> nftCollectionList,
      {Function(NFT token)? onSelected}) {
    List<NFTCollectionExpandableItem> widgets = [];

    for (int i = 0; i < nftCollectionList.length; i++) {
      final currentCollection = nftCollectionList[i];

      widgets.add(NFTCollectionExpandableItem(
        collection: currentCollection,
      ));
    }

    return widgets;
  }
}
