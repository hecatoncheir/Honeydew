library search_result;

import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:honeydew/services/routes/paths.dart' as paths;

import 'package:honeydew/components.dart'
    show TableComponent, PaginationComponent;

import 'package:honeydew/entities.dart'
    show
        Product,
        Company,
        Price,
        Column,
        ColumnDetails,
        Row,
        Cell,
        CellDetails,
        ProductsForPageSearchResponse;

@Component(
    selector: 'search-result',
    templateUrl: 'search_result.html',
    directives: const [TableComponent, PaginationComponent])
class SearchResultComponent {
  Router router;

  SearchResultComponent(this.router);

  ProductsForPageSearchResponse _searchResponse;
  ProductsForPageSearchResponse get searchResponse => _searchResponse;

  @Input()
  set searchResponse(ProductsForPageSearchResponse searchResponse) {
    this._searchResponse = searchResponse;

    prepareColumns(searchResponse.Products)
        .then((List<Column> columns) => this.columns = columns);

    prepareRows(searchResponse.Products)
        .then((List<Row> rows) => this.rows = rows);
  }

  void pageSelected(int currentSelectedPageNumber) {
    this.router.navigate(paths.searchWithPageParams.toUrl(parameters: {
          "text": searchResponse.SearchedName,
          "page": "$currentSelectedPageNumber"
        }));
  }

  List<Column> columns;
  List<Row> rows;

  Future<List<Column>> prepareColumns(List<Product> products) async {
    return prepareCompaniesOfProducts(products).then((List<Company> companies) {
      List<Column> columns = new List<Column>();

      String uidOfProductNameColumn = new Uuid().v4();
      Column columnOfProductName = new Column(
          uid: uidOfProductNameColumn, title: "Продукт", field: "productName");
      columns.add(columnOfProductName);

      for (Company company in companies) {
        Column companyColumn = new Column(
            uid: company.uid,
            title: company.companyName,
            field: company.companyName);

        companyColumn.details = new ColumnDetails(company: company);

        columns.add(companyColumn);
      }

      return columns;
    });
  }

  Future<List<Company>> prepareCompaniesOfProducts(
      List<Product> products) async {
    List<String> companiesUids = new List<String>();

    List<Company> companiesOfProductsPrices = new List<Company>();
    for (Product product in products) {
      for (Price price in product.hasPrice) {
        for (Company company in price.belongsToCompany) {
          if (companiesUids.contains(company.uid)) continue;
          companiesUids.add(company.uid);
          companiesOfProductsPrices.add(company);
        }
      }
    }

    return companiesOfProductsPrices;
  }

  Future<List<Row>> prepareRows(List<Product> products) async {
    List<Row> rows = new List<Row>();

    for (Product product in products) {
      Map<String, Cell> cells = new Map<String, Cell>();

      if (product.hasPrice.length == 0) {
        print("Product ${product.productName} has no one price");
        continue;
      }

      Cell cellOfProductName = new Cell(
          uid: product.uid,
          field: "productName",
          details: new CellDetails(category: product.belongsToCategory.first),
          value: product.productName,
          rowId: product.uid);

      cells[cellOfProductName.field] = cellOfProductName;

      Price price = product.hasPrice.first;

      Cell cell = new Cell(
          uid: price.uid,
          rowId: product.uid,
          columnId: price.belongsToCompany.first.uid,
          field: price.belongsToCompany.first.companyName,
          value: price.priceValue.toString());

      if (price.belongsToCity != null && price.belongsToCity.isNotEmpty)
        cell.details =
            new CellDetails(city: price.belongsToCity.first, price: price);

      cells[cell.field] = cell;

      Row row = new Row(uid: product.uid, cells: cells);
      rows.add(row);
    }

    return rows;
  }
}
