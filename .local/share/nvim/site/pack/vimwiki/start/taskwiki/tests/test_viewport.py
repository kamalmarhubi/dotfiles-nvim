# -*- coding: utf-8 -*-
import os
from datetime import datetime
from tests.base import MultiSyntaxIntegrationTest


class TestViewportsTaskGeneration(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | +work)
    """

    vimoutput = """
    HEADER2(Work tasks | +work)
    * [ ] tag work task  #{uuid}
    """

    tasks = [
        dict(description="tag work task", tags=['work']),
    ]

    def execute(self):
        self.command("w", regex="written$", lines=1)


class TestViewportsTaskGenerationEmptyFilter(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks |)
    """

    vimoutput = """
    HEADER2(Work tasks |)
    * [ ] some task  #{uuid}
    """

    tasks = [
        dict(description="some task"),
    ]

    def execute(self):
        self.command("w", regex="written$", lines=1)


class TestViewportsTaskRemoval(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | -work)
    * [ ] tag work task  #{uuid}
    """

    vimoutput = """
    HEADER2(Work tasks | -work)
    """

    tasks = [
        dict(description="tag work task", tags=['work']),
    ]

    def execute(self):
        self.command("w", regex="written$", lines=1)


class TestViewportsContextTaskGeneration(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | @work)
    """

    vimoutput = """
    HEADER2(Work tasks | @work)
    * [ ] tag work task  #{uuid}
    """

    tasks = [
        dict(description="tag work task", tags=['work']),
    ]

    def execute(self):
        with open(self.taskrc_path, 'a') as f:
            f.write('context.work=+work\n')

        self.command("w", regex="written$", lines=1)


class TestViewportsContextComplexFilterTaskGeneration(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | @work or project:Home)
    """

    vimoutput = """
    HEADER2(Work tasks | @work or project:Home)
    * [ ] home project task  #{uuid}
    * [ ] tag work task  #{uuid}
    """

    tasks = [
        dict(description="tag work task", tags=['work']),
        dict(description="home project task", project='Home'),
    ]

    def execute(self):
        with open(self.taskrc_path, 'a') as f:
            f.write('context.work=+work\n')

        self.command("w", regex="written$", lines=1)


class TestViewportsTwoContextTaskGeneration(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | @work or @home)
    """

    vimoutput = """
    HEADER2(Work tasks | @work or @home)
    * [ ] home project task  #{uuid}
    * [ ] tag work task  #{uuid}
    """

    tasks = [
        dict(description="tag work task", tags=['work']),
        dict(description="home project task", project='Home'),
    ]

    def execute(self):
        with open(self.taskrc_path, 'a') as f:
            f.write('context.work=+work\n')
            f.write('context.home=project:Home\n')

        self.command("w", regex="written$", lines=1)


class TestViewportsContextInvalid(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | @doesnotexist)
    """

    vimoutput = """
    HEADER2(Work tasks | @doesnotexist)
    """

    def execute(self):
        self.command("w", regex="Context definition for 'doesnotexist' "
                                "could not be found.", lines=3)


class TestViewportDefaultsAssigment(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | +work)
    * [ ] tag work task
    """

    vimoutput = """
    HEADER2(Work tasks | +work)
    * [ ] tag work task  #{uuid}
    """

    def execute(self):
        self.command("w", regex="written$", lines=1)
        assert len(self.tw.tasks.pending()) == 1

        task = self.tw.tasks.pending()[0]
        assert task['description'] == 'tag work task'
        assert task['status'] == 'pending'
        assert task['tags'] == set(['work'])


class TestViewportDefaultsExplicit(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | project:Home +home | project:Chores)
    * [ ] home task
    """

    vimoutput = """
    HEADER2(Work tasks | project:Home +home | project:Chores)
    """

    def execute(self):
        self.command("w", regex="written$", lines=1)
        assert len(self.tw.tasks.pending()) == 1

        task = self.tw.tasks.pending()[0]
        assert task['description'] == 'home task'
        assert task['status'] == 'pending'
        assert task['project'] == 'Chores'
        assert task['tags'] == set()


class TestViewportDefaultsExplicitEmpty(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | project:Home +home | project:)
    * [ ] home task
    """

    vimoutput = """
    HEADER2(Work tasks | project:Home +home | project:)
    """

    def execute(self):
        self.command("w", regex="written$", lines=1)
        assert len(self.tw.tasks.pending()) == 1

        task = self.tw.tasks.pending()[0]
        assert task['description'] == 'home task'
        assert task['status'] == 'pending'
        assert task['project'] == None
        assert task['tags'] == set()


class TestViewportDefaultsTerminatedByHeader(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | +work)
    * [ ] tag work task

    HEADER2(Unrelated work tasks)
    * [ ] not tagged work task
    """

    vimoutput = """
    HEADER2(Work tasks | +work)
    * [ ] tag work task  #{uuid}

    HEADER2(Unrelated work tasks)
    * [ ] not tagged work task  #{uuid}
    """

    def execute(self):
        self.command("w", regex="written$", lines=1)
        assert len(self.tw.tasks.pending()) == 2

        task = self.tw.tasks.filter('+work')[0]
        assert task['description'] == 'tag work task'
        assert task['status'] == 'pending'
        assert task['tags'] == set(['work'])

        task = self.tw.tasks.filter('-work')[0]
        assert task['description'] == 'not tagged work task'
        assert task['status'] == 'pending'
        assert task['tags'] == set()


class TestViewportInspection(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | +work)
    * [ ] tag work task  #{uuid}
    """

    vimoutput = """
    ViewPort inspection:
    --------------------
    Name: Work tasks
    Filter used: -DELETED -PARENT ( +work )
    Defaults used: tags:['work']
    Ordering used: status+,end+,due+,priority-,project+
    Matching taskwarrior tasks: 1
    Displayed tasks: 1
    Tasks to be added:
    Tasks to be deleted:
    """

    tasks = [
        dict(description="tag work task", tags=['work']),
    ]

    def execute(self):
        self.command("w", regex="written$", lines=1)
        self.client.feedkeys('1gg')
        self.client.feedkeys(r'\<CR>')
        self.client.eval('0')  # wait for command completion

        assert self.py("print(vim.current.buffer)", regex="<buffer taskwiki.")


class TestViewportInspectionWithVisibleTag(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | +work -VISIBLE)
    * [ ] tag work task  #{uuid}

    HEADER2(Home tasks | +home)
    * [ ] tag work task  #{uuid}
    """

    vimoutput = """
    ViewPort inspection:
    --------------------
    Name: Work tasks
    Filter used: -DELETED -PARENT ( +work )
    Defaults used: tags:['work']
    Ordering used: status+,end+,due+,priority-,project+
    Matching taskwarrior tasks: 0
    Displayed tasks: 0
    Tasks to be added:
    Tasks to be deleted:
    """

    tasks = [
        dict(description="tag work task", tags=['work', 'home']),
    ]

    def execute(self):
        self.command("w", regex="written$", lines=1)
        self.client.feedkeys('1gg')
        self.client.feedkeys(r'\<CR>')
        self.client.eval('0')  # wait for command completion

        assert self.py("print(vim.current.buffer)", regex="<buffer taskwiki.")


class TestViewportsUnicodeTaskGeneration(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | +work)
    """

    vimoutput = u"""
    HEADER2(Work tasks | +work)
    * [ ] tag work täsk  #{uuid}
    """

    tasks = [
        dict(description=u"tag work täsk", tags=['work']),
    ]

    def execute(self):
        self.command("w", regex="written$", lines=1)


class TestUnicodeViewportsUnicodeTaskGeneration(MultiSyntaxIntegrationTest):

    viminput = u"""
    HEADER2(Réunion 2017 | project:Réunion2017)
    """

    vimoutput = u"""
    HEADER2(Réunion 2017 | project:Réunion2017)
    * [ ] Réunion task 1  #{uuid}
    """

    tasks = [
        dict(description=u"Réunion task 1", project=u'Réunion2017'),
    ]

    def execute(self):
        self.command("w", regex="written$", lines=1)
        assert len(self.tw.tasks.pending()) == 1


class TestUnicodeViewportsUnicodeDefaultsAssignment(MultiSyntaxIntegrationTest):

    viminput = u"""
    HEADER2(Réunion 2017 | project:Réunion2017)
    * [ ] Réunion task 1
    """

    vimoutput = u"""
    HEADER2(Réunion 2017 | project:Réunion2017)
    * [ ] Réunion task 1  #{uuid}
    """

    def execute(self):
        self.command("w", regex="written$", lines=1)
        assert len(self.tw.tasks.pending()) == 1

        task = self.tw.tasks.pending()[0]
        assert task['description'] == u'Réunion task 1'
        assert task['status'] == 'pending'
        assert task['project'] == u'Réunion2017'


class TestViewportsSortedGeneration(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | +work)
    """

    vimoutput = """
    HEADER2(Work tasks | +work)
    * [ ] main task 1 (2015-08-07)  #{uuid}
        * [ ] sub task 1a (2015-08-01)  #{uuid}
            * [ ] sub task 1aa  #{uuid}
        * [ ] sub task 1b  #{uuid}
    * [ ] main task 2 (2015-08-08)  #{uuid}
    * [ ] main task 3 (2015-08-09)  #{uuid}
        * [ ] sub task 3a (2015-08-03)  #{uuid}
        * [ ] sub task 3b  #{uuid}
    * [ ] main task 4  #{uuid}
    """

    tasks = [
        dict(description="main task 3", tags=['work'], due=datetime(2015,8,9)),
        dict(description="main task 2", tags=['work'], due=datetime(2015,8,8)),
        dict(description="main task 1", tags=['work'], due=datetime(2015,8,7)),
        dict(description="main task 4", tags=['work']),
        dict(description="sub task 1b", tags=['work']),
        dict(description="sub task 1a", tags=['work'], due=datetime(2015,8,1)),
        dict(description="sub task 1aa", tags=['work']),
        dict(description="sub task 3b", tags=['work']),
        dict(description="sub task 3a", tags=['work'], due=datetime(2015,8,3)),
    ]

    def execute(self):
        # Mark the dependencies
        self.tasks[2]['depends'].add(self.tasks[4])
        self.tasks[2]['depends'].add(self.tasks[5])
        self.tasks[0]['depends'].add(self.tasks[7])
        self.tasks[0]['depends'].add(self.tasks[8])
        self.tasks[5]['depends'].add(self.tasks[6])

        for task in self.tasks:
            task.save()

        self.command("w", regex="written$", lines=1)


class TestViewportsSortedGenerationReverse(TestViewportsSortedGeneration):

    vimoutput = """
    HEADER2(Work tasks | +work)
    * [ ] main task 3 (2015-08-09)  #{uuid}
        * [ ] sub task 3a (2015-08-03)  #{uuid}
        * [ ] sub task 3b  #{uuid}
    * [ ] main task 2 (2015-08-08)  #{uuid}
    * [ ] main task 1 (2015-08-07)  #{uuid}
        * [ ] sub task 1a (2015-08-01)  #{uuid}
            * [ ] sub task 1aa  #{uuid}
        * [ ] sub task 1b  #{uuid}
    * [ ] main task 4  #{uuid}
    """

    def execute(self):
        # Change the ordering
        self.command('let g:taskwiki_sort_order="due-"')

        # Otherwise everything from previous test should be preserved
        super(TestViewportsSortedGenerationReverse, self).execute()


class TestViewportsMultilevelSortedGeneration(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | project:Work or project:Home)
    """

    vimoutput = """
    HEADER2(Work tasks | project:Work or project:Home)
    * [ ] home task 1 (2015-08-01)  #{uuid}
    * [ ] home task 2 (2015-08-02)  #{uuid}
    * [ ] home task 3 (2015-08-03)  #{uuid}
    * [ ] work task 1 (2015-08-01)  #{uuid}
    * [ ] work task 2 (2015-08-02)  #{uuid}
    * [ ] work task 3 (2015-08-03)  #{uuid}
    """

    tasks = [
        dict(description="home task 1", project="Home", due=datetime(2015,8,1)),
        dict(description="home task 2", project="Home", due=datetime(2015,8,2)),
        dict(description="home task 3", project="Home", due=datetime(2015,8,3)),
        dict(description="work task 1", project="Work", due=datetime(2015,8,1)),
        dict(description="work task 2", project="Work", due=datetime(2015,8,2)),
        dict(description="work task 3", project="Work", due=datetime(2015,8,3)),
    ]

    def execute(self):
        # Change the ordering
        self.command('let g:taskwiki_sort_order="project,due"')

        # Generate the tasks
        self.command("w", regex="written$", lines=1)


class TestViewportsSpecificSorting(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | project:Work or project:Home $T)
    """

    vimoutput = """
    HEADER2(Work tasks | project:Work or project:Home $T)
    * [ ] home task 1 (2015-08-01)  #{uuid}
    * [ ] home task 2 (2015-08-02)  #{uuid}
    * [ ] work task 1 (2015-08-01)  #{uuid}
    * [ ] work task 2 (2015-08-02)  #{uuid}
    """

    tasks = [
        dict(description="home task 1", project="Home", due=datetime(2015,8,1)),
        dict(description="home task 2", project="Home", due=datetime(2015,8,2)),
        dict(description="work task 1", project="Work", due=datetime(2015,8,1)),
        dict(description="work task 2", project="Work", due=datetime(2015,8,2)),
    ]

    def execute(self):
        # Define the ordering T
        self.command('let g:taskwiki_sort_orders={"T": "project,due"}')

        # Generate the tasks
        self.command("w", regex="written$", lines=1)


class TestViewportsSpecificSortingCombined(TestViewportsSpecificSorting):

    viminput = """
    HEADER2(Work tasks | project:Work or project:Home $T)

    HEADER2(Work tasks | project:Work or project:Home)
    """

    vimoutput = """
    HEADER2(Work tasks | project:Work or project:Home $T)
    * [ ] home task 1 (2015-08-01)  #{uuid}
    * [ ] home task 2 (2015-08-02)  #{uuid}
    * [ ] work task 1 (2015-08-01)  #{uuid}
    * [ ] work task 2 (2015-08-02)  #{uuid}

    HEADER2(Work tasks | project:Work or project:Home)
    * [ ] home task 1 (2015-08-01)  #{uuid}
    * [ ] work task 1 (2015-08-01)  #{uuid}
    * [ ] home task 2 (2015-08-02)  #{uuid}
    * [ ] work task 2 (2015-08-02)  #{uuid}
    """


class TestViewportsSortedInvalidOrder(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | +work $X)
    """

    vimoutput = """
    HEADER2(Work tasks | +work $X)
    """

    def execute(self):
        # Check that proper error message is raised
        self.command("w", regex="Sort indicator 'X' for viewport "
            "'Work tasks' is not defined, using default.", lines=2)


class TestViewportsCount(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | project:Work or project:Home limit:2)
    """

    vimoutput = """
    HEADER2(Work tasks | project:Work or project:Home limit:2)
    * [ ] home task 1 (2015-08-01)  #{uuid}
    * [ ] work task 1 (2015-08-01)  #{uuid}
    """

    tasks = [
        dict(description="home task 1", project="Home", due=datetime(2015,8,1)),
        dict(description="home task 2", project="Home", due=datetime(2015,8,2)),
        dict(description="work task 1", project="Work", due=datetime(2015,8,1)),
        dict(description="work task 2", project="Work", due=datetime(2015,8,2)),
    ]

    def execute(self):
        # Generate the tasks
        self.command("w", regex="written$", lines=1)


class TestViewportsVisibleMetaTag(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Home tasks | project:Home -VISIBLE)

    HEADER2(Chores | project:Home.Chores)
    """

    vimoutput = """
    HEADER2(Home tasks | project:Home -VISIBLE)
    * [ ] home task  #{uuid}

    HEADER2(Chores | project:Home.Chores)
    * [ ] chore task  #{uuid}
    """

    tasks = [
        dict(description="home task", project='Home.Random'),
        dict(description="chore task", project='Home.Chores'),
    ]

    def execute(self):
        # Currently, two saves are necessary for VISIBLE to take effect
        self.command("w", regex="written$", lines=1)
        self.command("w", regex="written$", lines=1)


class TestViewportsPreserveHierarchyUponCompletion(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | +work)
    * [ ] main task
        * [ ] sub task a
        * [ ] sub task b
    """

    vimoutput = """
    HEADER2(Work tasks | +work)
    * [ ] main task  #{uuid}
        * [X] sub task a  #{uuid}
        * [ ] sub task b  #{uuid}
    """

    def execute(self):
        self.command("w", regex="written$", lines=1)
        self.client.feedkeys('3gg')
        self.client.feedkeys(r'\\td')
        self.command("w", regex="written$", lines=1)


class TestViewportDefaultPreservesTags(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks | +work)
    * [ ] hard task -- +hard
    """

    vimoutput = """
    HEADER2(Work tasks | +work)
    * [ ] hard task  #{uuid}
    """

    def execute(self):
        self.command("w", regex="written$", lines=1)

        # Make sure both tags were preserved
        task = self.tw.tasks.pending()[0]
        assert task['description'] == 'hard task'
        assert task['status'] == 'pending'
        assert task['tags'] == set(['work', 'hard'])


class TestViewportBufferModified(MultiSyntaxIntegrationTest):

    viminput = """
    HEADER2(Work tasks |)
    * [ ] a task  #{uuid}
    """

    tasks = [
        dict(description="a task", tags=['work']),
    ]

    def execute(self):
        testfile2 = os.path.join(self.dir, "testwiki2.txt")
        testfile3 = os.path.join(self.dir, "testwiki3.txt")

        self.command("w", regex="written$", lines=1)
        self.command("w {}".format(testfile2), regex="written$", lines=1)
        self.command("1w {}".format(testfile3), regex="written$", lines=1)

        # testfile2 has the task, so refresh on open shouldn't change anything
        self.client.edit(testfile2)
        assert self.client.eval('&modified') == '0'

        # testfile3 only has header, so refresh on open makes changes
        self.client.edit(testfile3)
        assert self.client.eval('&modified') == '1'
