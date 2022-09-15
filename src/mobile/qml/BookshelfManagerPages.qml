import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3

Item {
    id: bookshelfPages

    property alias index: pages.currentIndex

    enum PageName {
        Task=0,
        UpdateSourcesQuestion=1,
        UpdateSources=2,
        ChooseSources=3,
        ChooseLanguages=4,
        ChooseDocuments=5,
        InstallDocuments=6,
        UpdateDocuments=7,
        RemoveDocuments=8
    }

    function initialize() {
        pages.currentIndex = BookshelfManagerPages.PageName.Task
        initPage();
        updateSourcesQuestionPage.update = false;
        taskPage.install = true;
    }

    function nextPage() {
        donePage();
        if (taskPage.remove)
            nextRemovePage();
        else if (taskPage.update)
            nextUpdatePage();
        else
            nextInstallPage();
        initPage();
    }

    function nextInstallPage() {
        if (index === BookshelfManagerPages.PageName.Task) {
            index = BookshelfManagerPages.PageName.UpdateSourcesQuestion
        } else if (index === BookshelfManagerPages.PageName.UpdateSourcesQuestion) {
            if (updateSourcesQuestionPage.update)
                index = BookshelfManagerPages.PageName.UpdateSources;
            else
                index = BookshelfManagerPages.PageName.ChooseSources;
        } else if (index === BookshelfManagerPages.PageName.UpdateSources) {
            index = BookshelfManagerPages.PageName.ChooseSources;
        } else if (index === BookshelfManagerPages.PageName.ChooseSources) {
            index = BookshelfManagerPages.PageName.ChooseLanguages;
        } else if (index === BookshelfManagerPages.PageName.ChooseLanguages) {
            index = BookshelfManagerPages.PageName.ChooseDocuments;
        } else if (index === BookshelfManagerPages.PageName.ChooseDocuments)
            index = BookshelfManagerPages.PageName.InstallDocuments;
    }

    function nextUpdatePage() {
        if (index === BookshelfManagerPages.PageName.Task) {
            index = BookshelfManagerPages.PageName.UpdateSourcesQuestion;
        } else if (index === BookshelfManagerPages.PageName.UpdateSourcesQuestion) {
            if (updateSourcesQuestionPage.update)
                index = BookshelfManagerPages.PageName.UpdateSources;
            else
                index = BookshelfManagerPages.PageName.UpdateDocuments;
        } else if (index === BookshelfManagerPages.PageName.UpdateSources) {
            index = BookshelfManagerPages.PageName.UpdateDocuments;
        } else if (index === BookshelfManagerPages.PageName.UpdateDocuments)
            index = BookshelfManagerPages.PageName.InstallDocuments;

    }

    function nextRemovePage() {
        if (index === BookshelfManagerPages.PageName.Task) {
            index = BookshelfManagerPages.PageName.RemoveDocuments
        }
    }

    function prevPage() {
        if (taskPage.remove)
            prevRemovePage();
        else if (taskPage.update)
            prevUpdatePage();
        else
            prevInstallPage();
        initPage();
    }

    function prevInstallPage() {
        if (index === BookshelfManagerPages.PageName.InstallDocuments)
            index = BookshelfManagerPages.PageName.ChooseDocuments;
        else if (index === BookshelfManagerPages.PageName.ChooseDocuments)
            index = BookshelfManagerPages.PageName.ChooseLanguages;
        else if (index === BookshelfManagerPages.PageName.ChooseLanguages)
            index = BookshelfManagerPages.PageName.ChooseSources;
        else if (index === BookshelfManagerPages.PageName.ChooseSources)
            index = BookshelfManagerPages.PageName.UpdateSourcesQuestion;
        else if (index === BookshelfManagerPages.PageName.UpdateSources)
            index = BookshelfManagerPages.PageName.UpdateSourcesQuestion;
        else if (index === BookshelfManagerPages.PageName.UpdateSourcesQuestion)
            index = BookshelfManagerPages.PageName.Task;
    }

    function prevUpdatePage() {
        if (index === BookshelfManagerPages.PageName.InstallDocuments)
            index = BookshelfManagerPages.PageName.UpdateDocuments;
        else if (index === BookshelfManagerPages.PageName.UpdateDocuments)
            index = BookshelfManagerPages.PageName.Task;
    }

    function prevRemovePage() {
        if (index === BookshelfManagerPages.PageName.RemoveDocuments)
            index = BookshelfManagerPages.PageName.Task;
    }

    function initPage() {
        var page = currentItem(pages.currentIndex);
        page.initPage();
    }

    function donePage() {
        var page = currentItem(pages.currentIndex);
        page.donePage();
    }

    function currentItem(index) {
        if (index === BookshelfManagerPages.PageName.Task) {
            return taskPage;
        }
        else if (index === BookshelfManagerPages.PageName.UpdateSourcesQuestion) {
            return updateSourcesQuestionPage;
        }
        else if (index === BookshelfManagerPages.PageName.UpdateSources) {
            return updateSourcesPage;
        }
        else if (index === BookshelfManagerPages.PageName.ChooseSources) {
            return chooseSourcesPage;
        }
        else if (index === BookshelfManagerPages.PageName.ChooseLanguages) {
            return chooseLanguagesPage;
        }
        else if (index === BookshelfManagerPages.PageName.ChooseDocuments) {
            return chooseDocumentPage;
        }
        else if (index === BookshelfManagerPages.PageName.InstallDocuments) {
            return installDocumentsPage;
        }
        else if (index === BookshelfManagerPages.PageName.UpdateDocuments) {
            return updateDocumentsPage;
        }
        else if (index === BookshelfManagerPages.PageName.RemoveDocuments) {
            return removeDocumentsPage;
        }
    }

    StackLayout {
        id: pages

        anchors.fill: parent
        currentIndex: 0
        z:2

        TaskPage {
            id: taskPage
        }

        UpdateSourcesQuestionPage {
            id: updateSourcesQuestionPage
        }

        UpdateSourcesPage {
            id: updateSourcesPage
        }

        ChooseSourcesPage {
            id: chooseSourcesPage
        }

        ChooseLanguagesPage {
            id: chooseLanguagesPage
        }

        ChooseDocumentsPage {
            id: chooseDocumentPage
        }

        InstallDocumentsPage {
            id: installDocumentsPage
        }

        UpdateDocumentsPage {
            id: updateDocumentsPage
        }

        RemoveDocumentsPage {
            id: removeDocumentsPage
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Material.background
    }
}
