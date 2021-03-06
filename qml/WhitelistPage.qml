import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3

import JadeDiamond 1.0
import PamAuthentication 0.1

Page {
    signal urlSelected(string url)

    header: PageHeader {
        id: header

        title: i18n.tr('Whitelist')
    }

    AuthenticationHandler {
        id: authHandler
        serviceName: root.applicationName

        property string urlToRemove

        onAuthenticationSucceeded: {
            JadeDiamond.removeWhitelist(urlToRemove);
        }
    }

    Label {
        id: description
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            margins: units.gu(1)
        }

        text: i18n.tr('List of allowed sites')
        textSize: Label.Small
        horizontalAlignment: Label.AlignHCenter
    }

    Label {
        anchors.centerIn: parent
        visible: JadeDiamond.whitelistCount === 0
        text: i18n.tr('No allowed sites')
    }

    Flickable {
        anchors {
            left: parent.left
            top: description.bottom
            right: parent.right
            bottom: parent.bottom
        }

        clip: true
        contentHeight: contentColumn.height + units.gu(4)

        ColumnLayout {
            id: contentColumn
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
            }
            spacing: 0

            Repeater {
                model: JadeDiamond.whitelist

                delegate: ListItem {
                    Label {
                        anchors {
                            fill: parent
                            leftMargin: units.gu(1)
                            rightMargin: units.gu(1)
                        }

                        text: model.url
                        verticalAlignment: Label.AlignVCenter
                    }

                    onClicked: urlSelected('http://' + model.url)  // the url is actually just a domain for the whitelist

                    leadingActions: ListItemActions {
                        actions: [
                            Action {
                                iconName: 'delete'
                                text: i18n.tr('Remove')
                                onTriggered: {
                                    authHandler.urlToRemove = model.url;
                                    // TRANSLATORS: %DOMAIN% will be automatically replaced with the domain being removed
                                    authHandler.authenticate(i18n.tr('Enter your password remove %DOMAIN% from the whitelist').replace('%DOMAIN%', model.url));
                                }
                            }
                        ]
                    }
                }
            }
        }
    }
}
