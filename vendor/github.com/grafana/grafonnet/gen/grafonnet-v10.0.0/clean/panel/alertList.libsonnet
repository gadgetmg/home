// This file is generated, do not manually edit.
(import '../../clean/panel.libsonnet')
+ {
  '#': { help: 'grafonnet.panel.alertList', name: 'alertList' },
  panelOptions+:
    {
      '#withType': { 'function': { args: [], help: '' } },
      withType(): {
        type: 'alertlist',
      },
    },
  options+:
    {
      '#withAlertListOptions': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withAlertListOptions(value): {
        options+: {
          AlertListOptions: value,
        },
      },
      '#withAlertListOptionsMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withAlertListOptionsMixin(value): {
        options+: {
          AlertListOptions+: value,
        },
      },
      AlertListOptions+:
        {
          '#withAlertName': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withAlertName(value): {
            options+: {
              alertName: value,
            },
          },
          '#withDashboardAlerts': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withDashboardAlerts(value=true): {
            options+: {
              dashboardAlerts: value,
            },
          },
          '#withDashboardTitle': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withDashboardTitle(value): {
            options+: {
              dashboardTitle: value,
            },
          },
          '#withFolderId': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withFolderId(value): {
            options+: {
              folderId: value,
            },
          },
          '#withMaxItems': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withMaxItems(value): {
            options+: {
              maxItems: value,
            },
          },
          '#withShowOptions': { 'function': { args: [{ default: null, enums: ['current', 'changes'], name: 'value', type: ['string'] }], help: '' } },
          withShowOptions(value): {
            options+: {
              showOptions: value,
            },
          },
          '#withSortOrder': { 'function': { args: [{ default: null, enums: [1, 2, 3, 4, 5], name: 'value', type: ['number'] }], help: '' } },
          withSortOrder(value): {
            options+: {
              sortOrder: value,
            },
          },
          '#withStateFilter': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withStateFilter(value): {
            options+: {
              stateFilter: value,
            },
          },
          '#withStateFilterMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withStateFilterMixin(value): {
            options+: {
              stateFilter+: value,
            },
          },
          stateFilter+:
            {
              '#withAlerting': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withAlerting(value=true): {
                options+: {
                  stateFilter+: {
                    alerting: value,
                  },
                },
              },
              '#withExecutionError': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withExecutionError(value=true): {
                options+: {
                  stateFilter+: {
                    execution_error: value,
                  },
                },
              },
              '#withNoData': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withNoData(value=true): {
                options+: {
                  stateFilter+: {
                    no_data: value,
                  },
                },
              },
              '#withOk': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withOk(value=true): {
                options+: {
                  stateFilter+: {
                    ok: value,
                  },
                },
              },
              '#withPaused': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withPaused(value=true): {
                options+: {
                  stateFilter+: {
                    paused: value,
                  },
                },
              },
              '#withPending': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withPending(value=true): {
                options+: {
                  stateFilter+: {
                    pending: value,
                  },
                },
              },
            },
          '#withTags': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withTags(value): {
            options+: {
              tags:
                (if std.isArray(value)
                 then value
                 else [value]),
            },
          },
          '#withTagsMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withTagsMixin(value): {
            options+: {
              tags+:
                (if std.isArray(value)
                 then value
                 else [value]),
            },
          },
        },
      '#withUnifiedAlertListOptions': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withUnifiedAlertListOptions(value): {
        options+: {
          UnifiedAlertListOptions: value,
        },
      },
      '#withUnifiedAlertListOptionsMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withUnifiedAlertListOptionsMixin(value): {
        options+: {
          UnifiedAlertListOptions+: value,
        },
      },
      UnifiedAlertListOptions+:
        {
          '#withAlertInstanceLabelFilter': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withAlertInstanceLabelFilter(value): {
            options+: {
              alertInstanceLabelFilter: value,
            },
          },
          '#withAlertName': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withAlertName(value): {
            options+: {
              alertName: value,
            },
          },
          '#withDashboardAlerts': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withDashboardAlerts(value=true): {
            options+: {
              dashboardAlerts: value,
            },
          },
          '#withDatasource': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withDatasource(value): {
            options+: {
              datasource: value,
            },
          },
          '#withFolder': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withFolder(value): {
            options+: {
              folder: value,
            },
          },
          '#withFolderMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withFolderMixin(value): {
            options+: {
              folder+: value,
            },
          },
          folder+:
            {
              '#withId': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
              withId(value): {
                options+: {
                  folder+: {
                    id: value,
                  },
                },
              },
              '#withTitle': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
              withTitle(value): {
                options+: {
                  folder+: {
                    title: value,
                  },
                },
              },
            },
          '#withGroupBy': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withGroupBy(value): {
            options+: {
              groupBy:
                (if std.isArray(value)
                 then value
                 else [value]),
            },
          },
          '#withGroupByMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withGroupByMixin(value): {
            options+: {
              groupBy+:
                (if std.isArray(value)
                 then value
                 else [value]),
            },
          },
          '#withGroupMode': { 'function': { args: [{ default: null, enums: ['default', 'custom'], name: 'value', type: ['string'] }], help: '' } },
          withGroupMode(value): {
            options+: {
              groupMode: value,
            },
          },
          '#withMaxItems': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withMaxItems(value): {
            options+: {
              maxItems: value,
            },
          },
          '#withShowInstances': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withShowInstances(value=true): {
            options+: {
              showInstances: value,
            },
          },
          '#withSortOrder': { 'function': { args: [{ default: null, enums: [1, 2, 3, 4, 5], name: 'value', type: ['number'] }], help: '' } },
          withSortOrder(value): {
            options+: {
              sortOrder: value,
            },
          },
          '#withStateFilter': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withStateFilter(value): {
            options+: {
              stateFilter: value,
            },
          },
          '#withStateFilterMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withStateFilterMixin(value): {
            options+: {
              stateFilter+: value,
            },
          },
          stateFilter+:
            {
              '#withError': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withError(value=true): {
                options+: {
                  stateFilter+: {
                    'error': value,
                  },
                },
              },
              '#withFiring': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withFiring(value=true): {
                options+: {
                  stateFilter+: {
                    firing: value,
                  },
                },
              },
              '#withInactive': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withInactive(value=true): {
                options+: {
                  stateFilter+: {
                    inactive: value,
                  },
                },
              },
              '#withNoData': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withNoData(value=true): {
                options+: {
                  stateFilter+: {
                    noData: value,
                  },
                },
              },
              '#withNormal': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withNormal(value=true): {
                options+: {
                  stateFilter+: {
                    normal: value,
                  },
                },
              },
              '#withPending': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withPending(value=true): {
                options+: {
                  stateFilter+: {
                    pending: value,
                  },
                },
              },
            },
          '#withViewMode': { 'function': { args: [{ default: null, enums: ['list', 'stat'], name: 'value', type: ['string'] }], help: '' } },
          withViewMode(value): {
            options+: {
              viewMode: value,
            },
          },
        },
    },
}
+ {
  panelOptions+: {
    '#withType':: {

    },
  },
}
