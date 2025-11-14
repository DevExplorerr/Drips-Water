import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/search/search_viewmodel.dart';
import 'package:drips_water/presentation/screens/search/widgets/search_results.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(),
      child: Consumer<SearchViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              leading: IconButton(
                padding: const EdgeInsets.only(left: 20),
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: SearchBar(
                    controller: vm.searchController,
                    hintText: "Search something...",
                    autoFocus: true,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.text,
                    leading: const Icon(Icons.search, color: AppColors.primary),
                    trailing: <Widget>[
                      IconButton(
                        onPressed: vm.clearSearch,
                        icon: const Icon(Icons.clear, color: AppColors.primary),
                      ),
                    ],
                    onChanged: vm.onSearchChanged,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  ),
                ),

                // Search Results Section
                Expanded(child: SearchResults(viewModel: vm)),
              ],
            ),
          );
        },
      ),
    );
  }
}
