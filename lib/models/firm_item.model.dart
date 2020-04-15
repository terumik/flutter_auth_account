class FormItem {
  final String key;
  final String title;
  final subtitleBuilder;
  final Function formBuilder;
  bool displayForm = false;

  FormItem({this.key, this.title, this.subtitleBuilder, this.formBuilder});
}
