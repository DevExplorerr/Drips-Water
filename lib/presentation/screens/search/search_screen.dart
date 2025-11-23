import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/logic/services/search_service.dart';
import 'package:drips_water/logic/view_models/product/search_view_model.dart';
import 'package:drips_water/presentation/screens/search/widgets/search_results.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(SearchService()),
      child: Consumer<SearchViewModel>(
        builder: (context, searchViewModel, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              leading: IconButton(
                padding: const EdgeInsets.only(left: 20),
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
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
                    controller: searchViewModel.searchController,
                    hintText: "Search something...",
                    autoFocus: true,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.text,
                    leading: const Icon(Icons.search, color: AppColors.primary),
                    trailing: [
                      IconButton(
                        onPressed: searchViewModel.clearSearch,
                        icon: const Icon(Icons.clear, color: AppColors.primary),
                      ),
                    ],
                    onChanged: searchViewModel.onSearchChanged,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  ),
                ),

                // Search Results Section
                Expanded(child: SearchResults(viewModel: searchViewModel)),
              ],
            ),
          );
        },
      ),
    );
  }
}
