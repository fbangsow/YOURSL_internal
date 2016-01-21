
              var startdateobj;
              var cancelclick = 1;
              var dataforna = 0;
              var universalobject = "";
              var clickedfoedata = 0;
              //Creating a module in angularjs
              var app = angular.module('myApp', []);
              //Dataset creation and loading calendar  
              app.factory('tempService', function () {
                  var factorytmp = {
                      "startDate": "01/02/2015",
                      "endDate": "28/02/2015",
                      "timeStamp": "2015-02-23 16:52:57",
                      "customers": [
                        {
                            "customerName": "CCEAG",
                            "projects": [
                              {
                                  "name": "Social Intranet",
                                  "responsible": "Andrii Slyshynskyi",
                                  "resources": [
                                    {
                                        "resourceName": "Jan Mensfeld",
                                        "staffing": "GC",
                                        "role": "DEV",
                                        "workload": "40",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "1250 ",
                                        "soldDays": "20,20",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": [
                                          {
                                              "day": "2015-02-03",
                                              "staff": "8"
                                          },
                                          {
                                              "day": "2015-02-04",
                                              "staff": "6"
                                          },
                                          {
                                              "day": "2015-02-05",
                                              "staff": "8"
                                          },
                                          {
                                              "day": "2015-02-06",
                                              "staff": "2"
                                          }
                                        ]
                                    },
                                    {
                                        "resourceName": "Kim Verheyden",
                                        "staffing": "GC",
                                        "role": "TA",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "900 ",
                                        "soldDays": "20,10",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": []
                                    },
                                    {
                                        "resourceName": "Dennis Kaspuhl",
                                        "staffing": "GC",
                                        "role": "DEV",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "900 ",
                                        "soldDays": "25,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": []
                                    },
                                    {
                                        "resourceName": "Sascha Weicht",
                                        "staffing": "GC",
                                        "role": "CON",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "900 ",
                                        "soldDays": "15,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": []
                                    }
                                  ]
                              },
                              {
                                  "name": "fsfa App",
                                  "responsible": "Kim Verheyden",
                                  "resources": [
                                    {
                                        "resourceName": "Jan Mensfeld",
                                        "staffing": "GC",
                                        "role": "DEV",
                                        "workload": "40",
                                        "planned": "20",
                                        "unplanned": "0",
                                        "rate": "1050 ",
                                        "soldDays": "20,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": [
                                          {
                                              "day": "2015-02-11",
                                              "staff": "8"
                                          },
                                          {
                                              "day": "2015-02-12",
                                              "staff": "6"
                                          }
                                        ]
                                    },
                                    {
                                        "resourceName": "Kim Verheyden",
                                        "staffing": "GC",
                                        "role": "TA",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "500 ",
                                        "soldDays": "20,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": []
                                    },
                                    {
                                        "resourceName": "Dennis Kaspuhl",
                                        "staffing": "GC",
                                        "role": "DEV",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "900",
                                        "soldDays": "25,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": [
                                          {
                                              "day": "2015-02-03",
                                              "staff": "8"
                                          },
                                          {
                                              "day": "2015-02-04",
                                              "staff": "6"
                                          },
                                          {
                                              "day": "2015-02-05",
                                              "staff": "8"
                                          },
                                          {
                                              "day": "2015-02-06",
                                              "staff": "2"
                                          }
                                        ]
                                    },
                                    {
                                        "resourceName": "Sascha Weicht",
                                        "staffing": "GC",
                                        "role": "CON",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "900 ",
                                        "soldDays": "15,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": []
                                    }
                                  ]
                              }
                            ]
                        },
                        {
                            "customerName": "DMAG",
                            "projects": [
                              {
                                  "name": "DMAG Project1",
                                  "responsible": "Kim Verheyden",
                                  "resources": [
                                    {
                                        "resourceName": "Jan Mensfeld",
                                        "staffing": "GC",
                                        "role": "DEV",
                                        "workload": "40",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "1250 ",
                                        "soldDays": "20,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": [
                                          {
                                              "day": "2015-02-10",
                                              "staff": "8"
                                          }

                                        ]
                                    },
                                    {
                                        "resourceName": "Kim Verheyden",
                                        "staffing": "GC",
                                        "role": "TA",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "900 ",
                                        "soldDays": "20,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": [
                                          {
                                              "day": "2015-02-03",
                                              "staff": "8"
                                          },
                                          {
                                              "day": "2015-02-04",
                                              "staff": "6"
                                          },
                                          {
                                              "day": "2015-02-05",
                                              "staff": "8"
                                          },
                                          {
                                              "day": "2015-02-06",
                                              "staff": "2"
                                          }
                                        ]
                                    },
                                    {
                                        "resourceName": "Dennis Kaspuhl",
                                        "staffing": "GC",
                                        "role": "DEV",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "900 ",
                                        "soldDays": "25,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": []
                                    },
                                    {
                                        "resourceName": "Sascha Weicht",
                                        "staffing": "GC",
                                        "role": "CON",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "900 ",
                                        "soldDays": "15,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": []
                                    }
                                  ]
                              }
                            ]
                        },
                        {
                            "customerName": "Studio71",
                            "projects": [
                              {
                                  "name": "Social Intranet",
                                  "responsible": "Kim Verheyden",
                                  "resources": [
                                    {
                                        "resourceName": "Jan Mensfeld",
                                        "staffing": "GC",
                                        "role": "DEV",
                                        "workload": "40",
                                        "planned": "20",
                                        "unplanned": "0",
                                        "rate": "1250",
                                        "soldDays": "20,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": [
                                          {
                                              "day": "2015-02-23",
                                              "staff": "8"
                                          },
                                          {
                                              "day": "2015-02-24",
                                              "staff": "6"
                                          },
                                          {
                                              "day": "2015-02-25",
                                              "staff": "8"
                                          },
                                          {
                                              "day": "2015-02-26",
                                              "staff": "2"
                                          }
                                        ]
                                    },
                                    {
                                        "resourceName": "Kim Verheyden",
                                        "staffing": "GC",
                                        "role": "TA",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "900 ",
                                        "soldDays": "20,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": [
                                          {
                                              "day": "2015-02-23",
                                              "staff": "8"
                                          },
                                          {
                                              "day": "2015-02-24",
                                              "staff": "6"
                                          },
                                          {
                                              "day": "2015-02-25",
                                              "staff": "8"
                                          },
                                          {
                                              "day": "2015-02-26",
                                              "staff": "2"
                                          }
                                        ]
                                    },
                                    {
                                        "resourceName": "Dennis Kaspuhl",
                                        "staffing": "GC",
                                        "role": "DEV",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "900",
                                        "soldDays": "25,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": []
                                    },
                                    {
                                        "resourceName": "Sascha Weicht",
                                        "staffing": "GC",
                                        "role": "CON",
                                        "planned": "40",
                                        "unplanned": "0",
                                        "rate": "900 ",
                                        "soldDays": "15,00",
                                        "latestMod": "2015-01-10",
                                        "comments": "",
                                        "totNoOfDays": "",
                                        "staffing": []
                                    }
                                  ]
                              }
                            ]
                        }
                      ],
                      "resources": [
                       {
                           "resourceName": "Jan Mensfeld",
                           "role": "CON",
                           "rate": "900",
                           "soldDays": "15,00",
                           "latestMod": "2015-01-10",
                           "planned": "40",
                           "unplanned": "0",
                           "totNoOfDays": "",
                           "staffing": [
                             {
                                 "day": "2015-02-03",
                                 "staff": "8"
                             },

                             {
                                 "day": "2015-02-02",
                                 "staff": "N/A"
                             },

                              {
                                  "day": "2015-02-05",
                                  "staff": "8"
                              },
                             {
                                 "day": "2015-02-06",
                                 "staff": "2"
                             },
                             {
                                 "day": "2015-02-09",
                                 "staff": "8"
                             }, {
                                 "day": "2015-02-10",
                                 "staff": "2"
                             }, {
                                 "day": "2015-02-13",
                                 "staff": "N/A"
                             }
                           ]
                       },
                        {
                            "resourceName": "Kim Verheyden",
                            "staffing": "GC",
                            "role": "TA",
                            "planned": "40",
                            "unplanned": "0",
                            "rate": "900 ",
                            "soldDays": "20,00",
                            "latestMod": "2015-01-10",
                            "comments": "",
                            "totNoOfDays": "",
                            "staffing": [
                             {
                                 "day": "2015-02-03",
                                 "staff": "8"
                             },
                              {
                                  "day": "2015-02-04",
                                  "staff": "6"
                              },
                             {
                                 "day": "2015-02-23",
                                 "staff": "8"
                             },
                             {
                                 "day": "2015-02-05",
                                 "staff": "8"
                             },
                             {
                                 "day": "2015-02-06",
                                 "staff": "2"
                             },
                              {
                                  "day": "2015-02-24",
                                  "staff": "6"
                              },
                              {
                                  "day": "2015-02-25",
                                  "staff": "8"
                              },
                              {
                                  "day": "2015-02-26",
                                  "staff": "2"
                              }
                            ]
                        },
                               {
                                   "resourceName": "Dennis Kaspuhl",
                                   "staffing": "GC",
                                   "role": "DEV",
                                   "planned": "40",
                                   "unplanned": "0",
                                   "rate": "900 ",
                                   "soldDays": "25,00",
                                   "latestMod": "2015-01-10",
                                   "comments": "",
                                   "totNoOfDays": "",
                                   "staffing": [
                                    {
                                        "day": "2015-02-03",
                                        "staff": "8"
                                    },
                             {
                                 "day": "2015-02-04",
                                 "staff": "6"
                             }, {
                                 "day": "2015-02-05",
                                 "staff": "8"
                             },
                             {
                                 "day": "2015-02-06",
                                 "staff": "2"
                             }
                                   ]
                               },
                               {
                                   "resourceName": "Sascha Weicht",
                                   "staffing": "GC",
                                   "role": "CON",
                                   "planned": "40",
                                   "unplanned": "0",
                                   "rate": "900 ",
                                   "soldDays": "15,00",
                                   "latestMod": "2015-01-10",
                                   "comments": "",
                                   "totNoOfDays": "",
                                   "staffing": []
                               }

                      ]

                  };

                  //This function is used to  bind  calender inputs to table
                  return function () {
                      universalobject = factorytmp;
                      var strtdate = factorytmp.startDate;
                      var enddate = factorytmp.endDate;

                      var splitstrtdate = strtdate.split("/");
                      var splitenddate = enddate.split("/");
                      var date = new Date(splitstrtdate[2], parseInt(splitstrtdate[1]) - 1, splitstrtdate[0]);
                      var dateforenddate = new Date(splitenddate[2], parseInt(splitenddate[1]) - 1, splitenddate[0]);


                      //difference between start date and end date
                      var oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
                      var firstDate = new Date(splitenddate[2], parseInt(splitenddate[1]) - 1, splitenddate[0]);
                      var secondDate = new Date(splitstrtdate[2], parseInt(splitstrtdate[1]) - 1, splitstrtdate[0]);
                      var diffDays = Math.round(Math.abs((firstDate.getTime() - secondDate.getTime()) / (oneDay)));

                      var data = "";
                      var weekdays = {};
                      weekdays['1'] = "MON";
                      weekdays['2'] = "TUE";
                      weekdays['3'] = "WED";
                      weekdays['4'] = "THU";
                      weekdays['5'] = "FRI";
                      weekdays['6'] = "SAT";
                      weekdays['7'] = "SUN";

                      var day = date.getDay();
                      var dateforenddate = parseInt(date.getDate());
                      var year = parseInt(date.getFullYear());
                      var month = parseInt(date.getMonth()) + 1;


                      if (day == 0) {
                          day = 7;
                      }
                      var k = parseInt(day);
                      var lp = leapYear(year);
                      var dt;
                      dt = dateforenddate;
                      for (j = 0; j <= parseInt(diffDays) ; j++) {
                          if (month == 2) {
                              if (lp) {
                                  if (dt == 30) {
                                      dt = 1;
                                      month = month + 1;
                                  }
                              }
                              else {
                                  if (dt == 29) {
                                      dt = 1;
                                      month = month + 1;
                                  }

                              }
                          }
                          if (month == 4 || month == 6 || month == 9 || month == 11) {

                              if (dt == 31) {
                                  dt = 1;
                                  month = month + 1;
                              }
                          }

                          if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {

                              if (month == 12) {
                                  if (dt == 32) {

                                      dt = 1;

                                      month = 1;
                                      year = year + 1;
                                  }
                              }
                              else if (dt == 32) {

                                  dt = 1;

                                  month = month + 1;
                              }


                          }


                          var a = year + "." + month + "." + dt;
                          var b = weekdays[k] + dt;
                          if (weekdays[k] == "SAT" || weekdays[k] == "SUN") {
                              data = data + '<td><input name="' + a + '"    class="inputfields greycolorsat" disabled="disabled"  ng-model-ngblur ng-focus="storevalue($event)"   ng-change="plannedCalculation($event,$parent.$parent.$parent.$index,$parent.$parent.$index,$index,' + b + ')"></input></td>';
                          }
                          else {
                              data = data + '<td><input name="' + a + '"  class="inputfields ' + weekdays[k] + dt + month + year + '"    ng-model-ngblur ng-focus="storevalue($event)"  ng-change="plannedCalculation($event,$parent.$parent.$parent.$index,$parent.$parent.$index,$index,\'' + a + '\')" ></input></td>';
                          }
                          dt++;

                          if (k % 7 == 0) {
                              k = 1;

                          } else {
                              k++;

                          }

                      }


                      data = "<td>{{dataval2.rate}} &euro;</td><td>{{dataval2.soldDays}}</td><td><input type='textbox'/></td><td class='staffing' style='display:none;'>{{dataval2.staffing}}</td><td class='widderclumn'></td>" + data;

                      return data;
                  };
              });
              //template for inputfields of calender Ends
              //Compile function for attaching template to scope Starts Here
              app.directive('compileData', function ($compile) {
                  return {
                      scope: true,
                      replace: true,
                      link: function (scope, element, attrs) {

                          var elmnt;

                          attrs.$observe('template', function (myTemplate) {
                              if (angular.isDefined(myTemplate)) {
                                  // compile the provided template against the current scope
                                  elmnt = $compile(myTemplate)(scope);

                                  element.html(""); // dummy "clear"

                                  element.append(elmnt);
                              }
                          });
                      }
                  };
              });


              //Directive for blur,keyup,keydown Starts Here
              app.directive(['focus', 'blur', 'change', 'keyup', 'keydown', 'keypress'].reduce(function (container, name) {
                  var directiveName = 'ng' + name[0].toUpperCase() + name.substr(1);

                  container[directiveName] = ['$parse', function ($parse) {
                      return function (scope, element, attr) {
                          var fn = $parse(attr[directiveName]);
                          element.bind(name, function (event) {
                              scope.$apply(function () {
                                  fn(scope, {
                                      $event: event
                                  });
                              });
                          });
                      };
                  }];

                  return container;
              }, {
              }
              ));

              //Controller Starts Here
              app.controller('MyCtrl', function ($scope, tempService, $compile) {

                  $scope.focusdata = "";
                  //code for template of binding input field of calender 
                  $scope.mainPage = tempService();
                  var myDataSet1 = $scope.dataval1;
                  $scope.dataval = universalobject;

                  //caculation for planned and unplanned days 
                  angular.forEach($scope.dataval.customers, function (customers, i) {
                      angular.forEach(customers.projects, function (projectss, i) {
                          angular.forEach(projectss.resources, function (resurce, i) {
                              $scope.planned = 0;
                              angular.forEach(resurce.staffing, function (staffing, i) {
                                  $scope.planned = parseInt(staffing.staff) + $scope.planned;
                              })
                              $scope.plannedindays = $scope.planned / 8;
                              var plnd = $scope.plannedindays.toString();

                              $scope.plannedindays = plnd.replace(".", ",");
                              $scope.rplce = resurce.soldDays.replace(",", ".");

                              $scope.plannedindays = $scope.plannedindays.replace(",", ".");

                              $scope.unplannedindays = parseFloat($scope.rplce) - parseFloat($scope.plannedindays);
                              $scope.unplannedindays = $scope.unplannedindays.toFixed(2);
                              var ab = $scope.unplannedindays.toString();
                              $scope.plannedindays = $scope.plannedindays.replace(".", ",");
                              $scope.unplannedindays = ab.replace(".", ",");
                              resurce.planne = "" + $scope.plannedindays + "";
                              resurce.unplanne = "" + $scope.unplannedindays + "";

                          })

                      })

                  })


                  myDataSet = $scope.dataval.customers;
                  startdateobj = $scope.dataval;

                  //Display customer and projects information on initial page load
                  var newthing = new Array();
                  var customer = new Array();
                  var projectload = new Array();
                  customer.push({ "value": "All Customer" });
                  projectload.push({ "value": "All projects" });
                  angular.forEach(myDataSet, function (a, b) {
                      var project = new Array();
                      angular.forEach(a.projects, function (an, b) {

                          projectload.push({ "value": an.name });
                          project.push({ "name": an.name });
                      })
                      newthing.push({ "customer": a.customerName, "project": project });
                      customer.push({ "value": a.customerName });
                     
                  })
                  $scope.persons = customer;
                  $scope.projectdetails = newthing;
                  var foo2 = _.unique(projectload, false, function (item, k, v) {
                      return item.value;
                  });
                  $scope.projectsselect = foo2;
                  $scope.blisterPackTemplateSelected = $scope.persons[0];
                  $scope.projectsSelecteddata = $scope.projectsselect[0];


                  //Function for storing resource allocation value onfocus event
                  $scope.storevalue = function (val) {
                      $scope.focusdata = val.currentTarget.value;
                      $(val.target).attr("id", "" + $scope.focusdata + "");

                  }


                  //Calculation of planned and unplanned hours and blur events  starts here
                  //logic to display popups for various scenerios like N/A and over allocation

                  $scope.plannedCalculation = function (a, b, c, d, g) {
                      var cmbineprnt = b + "/" + c + "/" + d;

                      var totalhours = "";
                      $scope.resourcename = $scope.dataval.customers[b].projects[c].resources[d].resourceName;
                      var dateofinput = g.split(".");
                      var newdatefordate = new Date(dateofinput[0], dateofinput[1] - 1, dateofinput[2]);
                      var resourceavialblty = $scope.dataval.resources;

                      angular.forEach(resourceavialblty, function (resa, resb) {
                          var resrceavltyobj = resa.resourceName;


                          if (resrceavltyobj == $scope.resourcename) {

                              if (resa.staffing != "") {

                                  angular.forEach(resa.staffing, function (resstfnga, restaggngb) {


                                      var dateofresourcetable = resstfnga.day;
                                      var dateofresourcetable = dateofresourcetable.split("-");
                                      var newdateforresoucetable = new Date(dateofresourcetable[0], dateofresourcetable[1] - 1, dateofresourcetable[2]);

                                      if (newdateforresoucetable.getFullYear() == newdatefordate.getFullYear() && newdateforresoucetable.getMonth() == newdatefordate.getMonth() && newdateforresoucetable.getDate() == newdatefordate.getDate()) {

                                          if (a.currentTarget.value != "") {

                                              if (resstfnga.staff == "N/A") {

                                                  a.currentTarget.value = "";

                                                  $(".appendtxt").text("This Resource is not available at this day");
                                                  $(".blurbackgrund,.popup").attr("style", "display:block");
                                                  $(".appndbtns").html("<input type='button' value='Ok'  class='closebtn'>")

                                                  dataforna = 1;

                                              }
                                              else if (parseInt(resstfnga.staff) + parseInt(a.currentTarget.value) > 8) {
                                                  if ($scope.focusdata != "") {
                                                      var recal = $scope.focusdata - parseInt(a.currentTarget.value);
                                                      var data = parseInt(resstfnga.staff) - recal
                                                      totalhours = data;

                                                  }
                                                  else {

                                                      var hoyrssum = parseInt(resstfnga.staff) + parseInt(a.currentTarget.value);
                                                      totalhours = hoyrssum;

                                                  }


                                                  if (totalhours > 8) {

                                                      $(".appendtxt").text("This is " + totalhours + "  hours for this day");
                                                      $(".blurbackgrund,.popup").attr("style", "display:block");
                                                      $(".appndbtns").html("<input type='button' value='Confirm'  class='cnfrmbtn' ng-click='functionnot(" + a.currentTarget.value + "," + cmbineprnt + "," + g + "," + totalhours + "," + $(a.target).attr("id") + ")'><input type='button' value='Cancel'  class='cancelbtn'>");
                                                      $(a.target).addClass('Cancelfun');
                                                      cancelclick = 0;
                                                  }
                                              }
                                          }

                                      }
                                  });
                              }
                          }
                      })








                      $(a.target).removeClass('greencolor greycolor redcolor nacolor white');
                      $scope.settingcolor(a);


                      //Validating input data entered using regular expression
                      var currentvalue = a.currentTarget.value;

                      var numbervalidation = new RegExp("^([0-9]{0,})$");


                      if (!numbervalidation.test(currentvalue)) {
                          a.currentTarget.value = "";
                          $(a.target).removeClass();

                      }
                      if (parseInt(currentvalue) == 0) {
                          a.currentTarget.value = "";
                          $(a.target).removeClass();

                      }



                      if (totalhours == "") {
                          totalhours = a.currentTarget.value;
                      }
                      var j = ""
                      $scope.resourceplanningcalc(a, cmbineprnt, g, totalhours, j)

                  }


                  //color coding uneversial function starts here
                  $scope.settingcolor = function (a) {
                      if (parseInt(a.currentTarget.value) == 8) {
                          $(a.target).addClass('greencolor');
                      }
                      if (parseInt(a.currentTarget.value) < 8) {
                          $(a.target).addClass('greycolor');
                      }
                      if (parseInt(a.currentTarget.value) > 8) {
                          $(a.target).addClass('redcolor');
                      }
                      if (a.currentTarget.value == "N/A") {
                          $(a.target).addClass('nacolor');

                      }
                  }
                  //color coding uneversial function ends here

                  //function to use for  plannngcaculation  starts here


                  $scope.resourceplanningcalc = function (a, cmbineprnt, g, h, j) {

                      var cmbineparentsplit = cmbineprnt.split("/");
                      var b = cmbineparentsplit[0];
                      var c = cmbineparentsplit[1];
                      var d = cmbineparentsplit[2];

                      var currentvalue = "";

                      if (typeof a === "string") {
                          currentvalue = a;

                      }
                      else {
                          currentvalue = a.currentTarget.value;
                      }


                      var uncal = 0;

                      if (cancelclick != 0) {


                         

                          if ($scope.focusdata != "") {

                              var datanull;
                              if (currentvalue == "") {
                                  datanull = 0

                              }
                              else {
                                  datanull = currentvalue;

                              }


                              uncal = parseInt(datanull) - parseInt($scope.focusdata);


                          }
                          else {

                              var dataforelse = currentvalue;
                              if (currentvalue == "") {
                                  dataforelse = 0;

                              }
                              uncal = parseFloat(dataforelse);

                              if (j != "") {
                                  uncal = parseInt(currentvalue) - parseInt(j);
                              }
                          }

                          var calclateperhour = uncal / 8;


                          //logic to calculate planned value for given resource     
                          $scope.plannedscope = $scope.dataval.customers[b].projects[c].resources[d].planne.replace(",", ".");

                          var spltpannd = parseFloat($scope.plannedscope) + calclateperhour;

                          $scope.unplannedscope = $scope.dataval.customers[b].projects[c].resources[d].unplanne.replace(",", ".");
                          //logic to calculate unplanned value for given resource
                          var spltunplanneddays = parseFloat($scope.unplannedscope) - calclateperhour;
                          spltpannd = spltpannd.toString().replace(".", ",");
                          spltunplanneddays = spltunplanneddays.toString().replace(".", ",");



                          $scope.dataval.customers[b].projects[c].resources[d].planne = spltpannd;


                          $scope.dataval.customers[b].projects[c].resources[d].unplanne = spltunplanneddays;
                          $scope.resourcename = $scope.dataval.customers[b].projects[c].resources[d].resourceName;

                          //logic to populate allocation in resource allocation table                  
                          var date = g.split(".");


                          var cmbinedate = date[0] + "-" + date[1] + "-" + date[2];
                          $scope.dataval.customers[b].projects[c].resources[d].staffing.push({ "day": cmbinedate, "staff": currentvalue });
                          angular.forEach($scope.dataval.resources, function (resource, i) {
                              var count = 0;


                              if (resource.resourceName == $scope.resourcename) {


                                  angular.forEach(resource.staffing, function (staffingdata, i) {

                                      var staffingdate = staffingdata.day.split("-");
                                      var newdateinput1 = new Date(date[0], date[1], date[2]);
                                      var jsonnewdate1 = new Date(staffingdate[0], staffingdate[1], staffingdate[2]);


                                      if (newdateinput1.getFullYear() == jsonnewdate1.getFullYear() && newdateinput1.getMonth() == jsonnewdate1.getMonth() && newdateinput1.getDate() == jsonnewdate1.getDate()) {


                                          if (dataforna != 1) {

                                              if (clickedfoedata == 1) {

                                                  if (currentvalue != "") {


                                                      if (staffingdata.staff != "") {
                                                          if (h > 8) {
                                                              staffingdata.staff = h;


                                                          }
                                                          else {

                                                              var recal = $scope.focusdata - currentvalue;
                                                              var data = parseInt(staffingdata.staff) - recal
                                                              staffingdata.staff = data;


                                                          }







                                                          count = 1;

                                                      }
                                                      else {

                                                          staffingdata.staff = parseInt(h);
                                                          count = 1;

                                                      }

                                                  }
                                                  else {

                                                      if (currentvalue == "") {
                                                          currentvalue = 0;
                                                      }

                                                      var recal = $scope.focusdata - currentvalue;
                                                      var data = parseInt(staffingdata.staff) - recal


                                                      if (staffingdata.staff == "") {

                                                          if (data == 0) {

                                                              data = "";


                                                          }
                                                      }

                                                      staffingdata.staff = data;

                                                      count = 1;

                                                  }
                                              }
                                              else {

                                                  if (currentvalue != "") {
                                                      if ($scope.focusdata != "") {
                                                          var recal = $scope.focusdata - currentvalue;
                                                          var data = parseInt(staffingdata.staff) - recal


                                                          if (staffingdata.staff == "") {

                                                              if (data == 0) {

                                                                  data = "";


                                                              }
                                                          }

                                                          staffingdata.staff = data;


                                                          count = 1;

                                                      }
                                                      else {
                                                          count = 1;

                                                          if (staffingdata.staff == "") {
                                                              staffingdata.staff = parseInt(currentvalue);

                                                          }
                                                          else {
                                                              staffingdata.staff = parseInt(staffingdata.staff) + parseInt(currentvalue);

                                                          }



                                                      }

                                                  }
                                                  else {
                                                      var recal = $scope.focusdata - currentvalue;
                                                      var data = parseInt(staffingdata.staff) - recal


                                                      if (staffingdata.staff == "") {

                                                          if (data == 0) {

                                                              data = "";


                                                          }
                                                      }

                                                      staffingdata.staff = data;

                                                      count = 1;

                                                  }


                                              }
                                          }
                                          if (parseInt(staffingdata.staff) == 0) {
                                              staffingdata.staff = "";

                                          }

                                      }



                                  })

                                  if (count != 1) {
                                      if (dataforna != 1) {
                                          if (currentvalue != "") {


                                              resource.staffing.push({ "day": cmbinedate, "staff": currentvalue });

                                              count = 0;
                                              dataforna = 0;
                                          }

                                      }
                                  }

                              }


                          });

                          fortotalinputs();

                          $scope.$apply();
                          $scope.staffingpopltion();
                       




                       
                      }






                  }



                  //function for populating staffing array in inputs 
                  $scope.staffingpopltion = function () {

                      $(".staffing").each(function () {

                          var jsondata = $(this).text();
                          if (jsondata != "[]") {
                              var th = $(this);
                              var jsonstrngfy = JSON.parse(jsondata);
                              $.each(jsonstrngfy, function (a, b) {

                                  $(th).parent().find(".inputfields").each(function () {

                                      var newdateinput = $(this).attr("name");
                                      var splitnewdateinput = newdateinput.split(".");
                                      var combinenewdateinput = splitnewdateinput[0] + "-" + splitnewdateinput[1] + "-" + splitnewdateinput[2];


                                      var jsonnewdate = b.day;
                                      var splitjsonnewdate = jsonnewdate.split("-");
                                      var combinejsonnewdate = splitjsonnewdate[2] + "-" + splitjsonnewdate[1] + "-" + splitjsonnewdate[0];


                                      var newdateinput1 = new Date(splitnewdateinput[0], parseInt(splitnewdateinput[1]) - 1, splitnewdateinput[2]);

                                      var jsonnewdate1 = new Date(splitjsonnewdate[0], parseInt(splitjsonnewdate[1]) - 1, splitjsonnewdate[2]);
                                      if (newdateinput1.getFullYear() == jsonnewdate1.getFullYear() && newdateinput1.getMonth() == jsonnewdate1.getMonth() && newdateinput1.getDate() == jsonnewdate1.getDate()) {


                                          $(this).removeClass('greencolor greycolor redcolor nacolor white');
                                          $(this).val(b.staff);
                                          if (b.staff == "8") {
                                              $(this).addClass("greencolor");
                                          }
                                          if (parseInt(b.staff) < 8) {
                                              $(this).addClass("greycolor");
                                          }
                                          if (parseInt(b.staff) > 8) {
                                              $(this).addClass("redcolor");
                                          }
                                          if (b.staff == "N/A") {
                                              $(this).addClass("nacolor");

                                          }

                                      }
                                  })
                              })
                          }
                      })
                  }

                  //Filtering of projects based on customer selection
                  $scope.customersfilter = function (ab) {

                  

                      var projects1 = new Array();
                      projects1.push({ "value": "All Projects" })
                      angular.forEach(newthing, function (a, b) {

                          if (a.customer == ab.value) {

                              angular.forEach(a.project, function (an, b) {

                                  projects1.push({ "value": an.name });

                              })
                          }
                          else if (ab.value == "All Customer") {


                              angular.forEach(a.project, function (an, b) {

                                  projects1.push({ "value": an.name });

                              })

                          }

                      })



                      $scope.projectsselect = "";
                      $scope.projectsselect = projects1;
                      if (ab.value == "All Customer") {
                          var projects1 = _.unique(projects1, false, function (item, k, v) {
                              return item.value;
                          });
                          $scope.projectsselect = projects1;
                      }

                      $scope.projectsSelecteddata = $scope.projectsselect[0];

                      $(".filterclass").attr("style", "display:block");
                      $(".maintable").attr("style", "display:none");


                      $("#contid table").each(function () {

                          $(this).removeClass("hidedata");
                          $(this).next().removeClass("hidedata");
                      })

                      if (ab.value != "All Customer") {
                          $(".customername").each(function () {
                              if ($(this).text() != ab.value) {
                                  $(this).parent().parent().parent().addClass("hidedata");
                                  $(this).parent().parent().parent().next().addClass("hidedata");

                              }
                          })
                      }



                  }


                  //filtering of table based on input selection
                  $scope.projects = function (ab1) {
                      if (ab1.value != "All Projects") {

                          $(".prjname").each(function () {

                              if ($(this).text() == ab1.value && $(this).parent().parent().find(".customername").text() == $scope.persons[parseInt($(".customers").val())].value) {
                                  $(this).parent().parent().parent().removeClass("hidedata");
                                  $(this).parent().parent().parent().next().removeClass("hidedata");




                              }
                              else {
                                  $(this).parent().parent().parent().addClass("hidedata");
                                  $(this).parent().parent().parent().next().addClass("hidedata");

                              }

                          })
                      }
                      else {
                          $(".prjname").each(function () {

                              if ($(this).parent().parent().find(".customername").text() == $scope.persons[parseInt($(".customers").val())].value) {
                                  $(this).parent().parent().parent().removeClass("hidedata");
                                  $(this).parent().parent().parent().next().removeClass("hidedata");




                              }
                              else {
                                  $(this).parent().parent().parent().addClass("hidedata");
                                  $(this).parent().parent().parent().next().addClass("hidedata");

                              }

                          })


                      }
                      if ($scope.persons[parseInt($(".customers").val())].value == "All Customer") {
                          $(".hdng table").each(function () {

                              $(this).removeClass("hidedata");
                              $(this).next().removeClass("hidedata");

                          })
                          $(".prjname").each(function () {

                              if ($(this).text() != ab1.value) {
                                  var a = ab1.value;

                               
                                  $(this).parent().parent().parent().addClass("hidedata");
                                  $(this).parent().parent().parent().next().addClass("hidedata");
                              }

                          })
                      }

                      if ($scope.persons[parseInt($(".customers").val())].value == "All Customer" && ab1.value == "All Projects") {
                          $(".hdng table").each(function () {

                              $(this).removeClass("hidedata");
                              $(this).next().removeClass("hidedata");

                          })
                      }


                  }



              });
              //Controller Ends Here

              //Functions of angularjs when is in document ready Starts here
              angular.element(document).ready(function () {
                  //date picker plugin starts here
                  $(".strtdateinput,.enddateinput").datepicker({
                      dateFormat: "dd-mm-yy"
                  });

                  //calculations for projectwise totals
                  angular.forEach(myDataSet, function (a, b) {
                      var customer = a.customerName;
                      angular.forEach(a.projects, function (a, b) {
                          var trdata = ""
                          var secondtable = ""
                          var plandtotal = 0;
                          var unplandtotal = 0;
                          var rate = 0;
                          var solddays = 0;
                          angular.forEach(a.resources, function (a, b) {
                              var plnd = (a.planne).toString().replace(",", ".");

                              var unplnddot = (a.unplanne).toString().replace(",", ".");
                              plandtotal = plandtotal + parseFloat(plnd);
                              unplandtotal = unplandtotal + parseFloat(unplnddot);


                              rate = rate + parseInt(a.rate);

                              var solddays1 = a.soldDays;
                              var splitsoldDays = solddays1.replace(",", ".");


                              var cmbine = parseFloat(splitsoldDays);
                              solddays = solddays + cmbine;




                          });
                          var eurosoliddays = euroconverter(solddays);
                          plandtotal = parseFloat(plandtotal).toFixed(2);
                          unplandtotal = parseFloat(unplandtotal).toFixed(2)

                          plandtotal = plandtotal.toString().replace(".", ",");
                          unplandtotal = unplandtotal.toString().replace(".", ",");
                          trdata = "<tr class='totalplannedandun'><td>Totals</td><td>" + plandtotal + "</td><td>" + unplandtotal + "</td><td></td></tr>";
                          secondtable = "<tr class='totalforcalndr'><td>" + rate + " &euro;</td><td>" + eurosoliddays + "</td><td></td></tr>"

                          $(".prjname").each(function () {

                              if ($(this).parent().prev().find(".customername").text() == customer && $(this).text() == a.name) {
                                  $(this).parent().parent().parent().next().find(".table1 .totalscalc").append(trdata);
                                  $(this).parent().parent().parent().next().find(".inputbdy").append(secondtable);

                              }
                          })


                      });
                  });



                  var strtdate = startdateobj.startDate;
                  var enddate = startdateobj.endDate;
                  var inputsplit = strtdate.split("/");

                  $(".strtdateinput").val(inputsplit[0] + "-" + inputsplit[1] + "-" + inputsplit[2]);

                  var splitstrtdate = strtdate.split("/");
                  var splitenddate = enddate.split("/");
                  $(".enddateinput").val(splitenddate[0] + "-" + splitenddate[1] + "-" + splitenddate[2]);
                  //differnce between startdate and end date starts
                  var oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
                  var firstDate = new Date(splitenddate[2], parseInt(splitenddate[1]) - 1, splitenddate[0]);
                  var secondDate = new Date(splitstrtdate[2], parseInt(splitstrtdate[1]) - 1, splitstrtdate[0]);

                  var diffDays = Math.round(Math.abs((firstDate.getTime() - secondDate.getTime()) / (oneDay)));

                  //differnce between startdate and end date ends

                  var date = new Date(splitstrtdate[2], parseInt(splitstrtdate[1]) - 1, splitstrtdate[0]);
                  var date1 = new Date(splitenddate[2], parseInt(splitenddate[1]) - 1, splitenddate[0]);


                  var weekdays = {};
                  weekdays['1'] = "MON";
                  weekdays['2'] = "TUE";
                  weekdays['3'] = "WED";
                  weekdays['4'] = "THU";
                  weekdays['5'] = "FRI";
                  weekdays['6'] = "SAT";
                  weekdays['7'] = "SUN";


                  var date = new Date(splitstrtdate[2], parseInt(splitstrtdate[1]) - 1, splitstrtdate[0]);

                  var heade;
                  var tableheade = "";
                  var day = date.getDay();
                  var date1 = parseInt(date.getDate());
                  var year = parseInt(date.getFullYear());
                  var month = parseInt(date.getMonth()) + 1;
                  if (day == 0) {
                      day = 7;
                  }
                  var k = parseInt(day);
                  var lp = leapYear(year);

                  var dt;
                  dt = date1;
                  for (j = 0; j <= parseInt(diffDays) ; j++) {
                      if (month == 2) {

                          if (lp) {
                              if (dt == 30) {

                                  dt = 1;
                                  month = month + 1;
                              }
                          }
                          else {

                              if (dt == 29) {
                                  dt = 1;
                                  month = month + 1;
                              }

                          }
                      }
                      if (month == 4 || month == 6 || month == 9 || month == 11) {

                          if (dt == 31) {
                              dt = 1;
                              month = month + 1;
                          }
                      }

                      if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {

                          if (month == 12) {
                              if (dt == 32) {

                                  dt = 1;

                                  month = 1;
                                  year = year + 1;
                              }
                          }
                          else if (dt == 32) {

                              dt = 1;

                              month = month + 1;
                          }


                      }

                      var cmbne = month + "-" + dt + "-" + year;

                      var weekno = moment(cmbne, "MM-DD-YYYY").startOf('isoweek').week();
                    

                      if (j == 0) {
                          if (k <= 4 || k == 7) {

                              heade = heade + "<th style='text-align:center;border-left:1px solid black;border-right:0;padding:0;border-top:none;' class='weekhead' ><span class='spanbirder' style='padding: 0% 19px 0 15px !important;'>Week-" + weekno + "</span><br/>" + weekdays[k] + '<br/> ' + dt + "/" + month + "/" + year + "</th>";

                          }
                      }
                      else if (weekdays[k] == "MON") {
                          heade = heade + "<th style='text-align:center;border:0;border-left:1px solid black;' class='weekhead' ><span class='spanbirder'></span><br/>" + weekdays[k] + '<br/> ' + dt + "/" + month + "/" + year + "</th>";
                      }
                      else if (weekdays[k] == "WED") {
                          heade = heade + "<th style='text-align:center;border:none;' class='weekhead' ><span class='spanbirder' style='padding: 0 14px 0 10px;'>Week-" + weekno + "</span><br/>" + weekdays[k] + '<br/> ' + dt + "/" + month + "/" + year + "</th>";
                      }
                      else {
                          heade = heade + "<th style='text-align:center;border:none;' class='weekhead' ><span class='spanbirder'></span><br/>" + weekdays[k] + '<br/> ' + dt + "/" + month + "/" + year + "</th>";
                      }


                      tableheade = tableheade + "<p style='float:left;'>" + weekdays[k] + '<br/> ' + dt + "/" + month + "/" + year + "</p>";

                      dt++;
                      if (k % 7 == 0) {
                          k = 1;

                      } else {
                          k++;

                      }

                  }
                  $(".table2 table thead tr").append(heade);
                  $(".table2 .one").append(tableheade);

                  angular.element(document.getElementById('contid')).scope().staffingpopltion();

                  $(".resourcetable").each(function () {
                      $(this).find("td").each(function (a) {
                          $(this).find("input").attr("disabled", true);
                          if (parseInt(a) <= 2) {

                              $(this).remove();
                          }

                      })
                  })

                  //calender total caluculation
                  totalcaluculation()
              })

              function totalcaluculation() {

                  $(".inputbdy").each(function () {
                      var count = 0;
                      var bdythis = $(this);
                      var txtx = "";
                      $(this).find("tr:first-child .inputfields").each(function () {
                          count = count + 1;
                          var a = $(this).attr("class");
                          splita = a.split(" ");

                          for (i = 0; i <= splita.length - 1; i++) {
                              if (splita[i] != "inputfields" && splita[i] != "greencolor" && splita[i] != "greycolor" && splita[i] != "redcolor") {

                                  var cls = splita[i];
                                  var valuee = 0;

                                  $(bdythis).find("." + cls + "").each(function () {
                                      if ($(this).val() != "") {

                                          valuee = valuee + parseInt($(this).val());
                                      }
                                  })

                                  txtx = txtx + "<td>" + valuee + "</td>";
                              }

                          }

                      });

                      $(this).find(".totalforcalndr").append(txtx);
                  });


              }

              //utility functions defined for this page       
              //function Europen number caluculation
              function euroconverter(number) {
                  var numberStr = parseFloat(number).toFixed(2).toString();
                  var numFormatDec = numberStr.slice(-2); /*decimal 00*/
                  numberStr = numberStr.substring(0, numberStr.length - 3); /*cut last 3 strings*/
                  var numFormat = new Array;
                  while (numberStr.length > 3) {
                      numFormat.unshift(numberStr.slice(-3));
                      numberStr = numberStr.substring(0, numberStr.length - 3);
                  }
                  numFormat.unshift(numberStr);
                  return numFormat.join('.') + ',' + numFormatDec; /*format 000.000.000,00 */
              }
              //function for leapyear caluclation
              function leapYear(year) {
                  return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
              }
              //function for colorsetting 
              function colorcoding() {
                  $(".Cancelfun").removeClass('greencolor greycolor redcolor nacolor white');

                  if ($(".Cancelfun").val() == "8") {
                      $(".Cancelfun").addClass("greencolor");

                  }
                  if (parseInt($(".Cancelfun").val()) < 8) {
                      $(".Cancelfun").addClass("greycolor");
                   
                  }
                  if (parseInt($(".Cancelfun").val()) > 8) {
                    
                      $(".Cancelfun").addClass("redcolor");
                  }
                  if ($(".Cancelfun").val() == "N/A") {
                      $(".Cancelfun").addClass("nacolor");

                  }
                  if ($(".Cancelfun").val() == "") {
                      $(".Cancelfun").addClass("white");
                     

                  }
                  $(".Cancelfun").removeClass('Cancelfun');
              }

              //Function for totals updating
              function fortotalinputs() {
                  $(".inputbdy").each(function () {
                      var count = 0;
                      var bdythis = $(this);
                      var txtx = "";
                      $(this).find("tr:first-child .inputfields").each(function () {
                          count = count + 1;
                          var a = $(this).attr("class");
                          splita = a.split(" ");

                          for (i = 0; i <= splita.length - 1; i++) {
                              if (splita[i] != "inputfields" && splita[i] != "greencolor" && splita[i] != "greycolor" && splita[i] != "redcolor" && splita[i] != "Cancelfun") {

                                  var cls = splita[i];
                                  var valuee = 0;

                                  $(bdythis).find("." + cls + "").each(function () {
                                      if ($(this).val() != "") {

                                          valuee = valuee + parseInt($(this).val());
                                      }
                                  })


                                  txtx = txtx + "<td>" + valuee + "</td>";
                              }

                          }
                      });

                      $(this).find(".totalforcalndr td").each(function (a) {
                          if (a > 2) {
                              $(this).remove();
                          }

                      })

                      $(this).find(".totalforcalndr").append(txtx);
                  });

                  //calculations for projectwise totals
                  $(".totalplannedandun").each(function () {
                      $(this).remove();
                  })
                  $.each(universalobject.customers, function (a, b) {
                      var customer = b.customerName;

                      $.each(b.projects, function (a, b) {
                          var trdata = ""
                          var secondtable = ""
                          var plandtotal = 0;
                          var unplandtotal = 0;
                          var rate = 0;
                          var solddays = 0;

                          $.each(b.resources, function (a, b) {
                              var plnd = (b.planne).toString().replace(",", ".");

                              var unplnddot = (b.unplanne).toString().replace(",", ".");
                              plandtotal = plandtotal + parseFloat(plnd);
                              unplandtotal = unplandtotal + parseFloat(unplnddot);


                              rate = rate + parseInt(b.rate);

                              var solddays1 = b.soldDays;
                              var splitsoldDays = solddays1.replace(",", ".");


                              var cmbine = parseFloat(splitsoldDays);
                              solddays = solddays + cmbine;




                          });
                          var eurosoliddays = euroconverter(solddays);
                          plandtotal = parseFloat(plandtotal).toFixed(2);
                          unplandtotal = parseFloat(unplandtotal).toFixed(2)

                          plandtotal = plandtotal.toString().replace(".", ",");
                          unplandtotal = unplandtotal.toString().replace(".", ",");
                          trdata = "<tr class='totalplannedandun'><td>Totals</td><td>" + plandtotal + "</td><td>" + unplandtotal + "</td><td></td></tr>";



                          $(".prjname").each(function () {

                              if ($(this).parent().prev().find(".customername").text() == customer && $(this).text() == b.name) {
                                  $(this).parent().parent().parent().next().find(".table1 .totalscalc").append(trdata);


                              }
                          })


                      });
                  });
              }


              //function for close button         
              $(document).on("click", ".closebtn", function () {
                  $(".blurbackgrund,.popup").attr("style", "display:none");
                  dataforna = 0;
              });

              //function for confrom button  
              $(document).on("click", ".cnfrmbtn", function () {
                  $(".blurbackgrund,.popup").attr("style", "display:none");
                  clickedfoedata = 1;

                  var splitdata = $(this).attr("ng-click").split("(");
                  cancelclick = 1;

                  var dataforbracket = splitdata[1].split(")");
                  var splitbycomma = dataforbracket[0].split(",");



                  var a = splitbycomma[0];
                  var b = splitbycomma[1];
                  var c = splitbycomma[2];
                  var d = splitbycomma[3];

                  var e = splitbycomma[4];






                  angular.element(document.getElementById('contid')).scope().resourceplanningcalc(a, b, c, d, e);
                  colorcoding();
              });
              //function for confrom button  ends here
              //function for cancel button starts here
              $(document).on("click", ".cancelbtn", function () {
                  $(".blurbackgrund,.popup").attr("style", "display:none");
                  $(".Cancelfun").val($('.Cancelfun').attr('id'));
                  cancelclick = 1;
                  colorcoding();

              });




