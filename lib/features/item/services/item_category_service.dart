import 'package:pujcovadlo_client/features/item/responses/item_category_response.dart';

class ItemCategoryService {
  Future<List<ItemCategoryResponse>> getCategories({String filter = ""}) async {
    Future.delayed(const Duration(seconds: 1));

    return [
      ItemCategoryResponse(id: 1, name: "Vrtačky", alias: "vrtacky"),
      ItemCategoryResponse(id: 2, name: "Pily", alias: "pily"),
      ItemCategoryResponse(id: 3, name: "Sekáče", alias: "sekace"),
      ItemCategoryResponse(id: 4, name: "Klíče", alias: "klice"),
      ItemCategoryResponse(id: 5, name: "Kladiva", alias: "kladiva"),
      ItemCategoryResponse(
          id: 6, name: "Pneumatické nářadí", alias: "pneumaticke-naradi"),
      ItemCategoryResponse(
          id: 7, name: "Elektrické nářadí", alias: "elektricke-naradi"),
      ItemCategoryResponse(id: 8, name: "Ruční nářadí", alias: "rucni-naradi"),
      ItemCategoryResponse(
          id: 9, name: "Zahradní nářadí", alias: "zahradni-naradi"),
      ItemCategoryResponse(
          id: 10, name: "Stavební nářadí", alias: "stavebni-naradi"),
      ItemCategoryResponse(
          id: 11, name: "Nářadí na auto", alias: "naradi-na-auto"),
      ItemCategoryResponse(
          id: 12, name: "Nářadí na kolo", alias: "naradi-na-kolo"),
      ItemCategoryResponse(
          id: 13, name: "Nářadí na motorku", alias: "naradi-na-motorku"),
      ItemCategoryResponse(
          id: 14,
          name: "Nářadí na zahradní techniku",
          alias: "naradi-na-zahradni-techniku"),
      ItemCategoryResponse(
          id: 15,
          name: "Nářadí na domácí spotřebiče",
          alias: "naradi-na-domaci-spotrebice"),
      ItemCategoryResponse(
          id: 16,
          name: "Nářadí na elektroniku",
          alias: "naradi-na-elektroniku"),
      ItemCategoryResponse(
          id: 17,
          name: "Nářadí na mobilní telefony",
          alias: "naradi-na-mobilni-telefony"),
      ItemCategoryResponse(
          id: 18, name: "Nářadí na počítače", alias: "naradi-na-pocitace"),
      ItemCategoryResponse(
          id: 19, name: "Nářadí na tablety", alias: "naradi-na-tablety"),
      ItemCategoryResponse(
          id: 20, name: "Nářadí na televize", alias: "naradi-na-televize"),
    ]
        .where((element) =>
            element.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }
}
