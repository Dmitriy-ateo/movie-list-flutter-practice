import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/blocs/search/search_bloc.dart';
import 'package:flutter_practice/blocs/search/search_event.dart';
import 'package:flutter_practice/blocs/search/search_state.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    _onSearchButtonPressed() {
      BlocProvider.of<SearchBloc>(context).add(
        SearchButtonPressed(
          movieName: _searchController.text,
        ),
      );
    }

    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  borderSide: BorderSide(width: 0.8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  borderSide: BorderSide(
                    width: 0.8,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                fillColor: Colors.grey[600],
                hasFloatingPlaceholder: false,
                hintText: 'Enter name ...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 20.0
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    state is! SearchLoading ? Icons.search : Icons.refresh,
                    size: 20.0,
                  ),
                  onPressed: 
                    state is! SearchLoading ? _onSearchButtonPressed : null,
                )
              ),
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          );
        }
      ),
    );
  }
}