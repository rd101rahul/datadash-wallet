import 'package:datadashwallet/features/portfolio/presentation/nfts/nft_list/widgets/nft_item.dart';
import 'package:flutter/material.dart';
import 'package:mxc_logic/mxc_logic.dart';
import 'package:mxc_ui/mxc_ui.dart';

class NFTCollectionExpandableItem extends StatefulWidget {
  final NFTCollection collection;

  const NFTCollectionExpandableItem({
    super.key,
    required this.collection,
  });

  @override
  State<NFTCollectionExpandableItem> createState() => _NFTCollectionState();
}

class _NFTCollectionState extends State<NFTCollectionExpandableItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              widget.collection.name,
              style: FontTheme.of(context).body2.primary(),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              '(${widget.collection.tokens.length})',
              style: FontTheme.of(context).body2.secondary(),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        collapsedTextColor: Colors.transparent,
        collapsedIconColor: ColorsTheme.of(context).textPrimary,
        iconColor: ColorsTheme.of(context).textPrimary,
        childrenPadding: EdgeInsets.zero,
        trailing: Icon(
          isExpanded
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          size: 24,
          color: ColorsTheme.of(context).iconPrimary,
        ),
        onExpansionChanged: (expansion) {
          setState(() {});
          isExpanded = expansion;
        },
        tilePadding: EdgeInsets.zero,
        children: [
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 10.0,
            shrinkWrap: true,
            children: widget.collection.tokens
                .map((e) => NFTItem(imageUrl: e.image))
                .toList(),
          ),
        ],
      ),
    );
  }
}
