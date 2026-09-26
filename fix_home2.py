filepath = 'lib/features/home/presentation/pages/home_screen.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# I need to restore `_SearchEntryState.build`
content = content.replace("""        child: AbsorbPointer(
          child: AppSearchField(
            controller: _controller,
            hint: widget.copy.searchHint,
            height: 40,
            hintColor: AppColors.inputHintStrong,
          ),
        ),
    );
  }
}""", """        child: AbsorbPointer(
          child: AppSearchField(
            controller: _controller,
            hint: widget.copy.searchHint,
            height: 40,
            hintColor: AppColors.inputHintStrong,
          ),
        ),
      ),
    );
  }
}""")

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
