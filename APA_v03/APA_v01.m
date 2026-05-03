classdef APA_v01 < matlab.apps.AppBase % Antenna Pattern Analyzer

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        GridLayout                    matlab.ui.container.GridLayout
        TabGroup                      matlab.ui.container.TabGroup
        Tab1_Single                   matlab.ui.container.Tab
        Tab1_Grid                     matlab.ui.container.GridLayout
        DropDown_output               matlab.ui.control.DropDown
        TabsData                      matlab.ui.container.TabGroup
        Tab_Output                    matlab.ui.container.Tab
        Grid_Output                   matlab.ui.container.GridLayout
        Table_DataOut                 matlab.ui.control.Table
        Tab_Input                     matlab.ui.container.Tab
        Grid_Input                    matlab.ui.container.GridLayout
        Table_DataIn                  matlab.ui.control.Table
        Panel_Cuts                    matlab.ui.container.Panel
        Grid_Cuts                     matlab.ui.container.GridLayout
        ExportCutButton               matlab.ui.control.Button
        E_LHCPCheckBox                matlab.ui.control.CheckBox
        E_RHCPCheckBox                matlab.ui.control.CheckBox
        E_TotalCheckBox               matlab.ui.control.CheckBox
        Label_HPBW                    matlab.ui.control.Label
        Button2                       matlab.ui.control.StateButton
        Tabs_Cuts                     matlab.ui.container.TabGroup
        Tab_Polar                     matlab.ui.container.Tab
        Grid_Polar                    matlab.ui.container.GridLayout
        Tab_Rect                      matlab.ui.container.Tab
        Grid_Rect                     matlab.ui.container.GridLayout
        Axes_Rect                     matlab.ui.control.UIAxes
        Tab_Filled                    matlab.ui.container.Tab
        Grid_Filled                   matlab.ui.container.GridLayout
        Axes_Filled                   matlab.ui.control.UIAxes
        Panel_Pattern                 matlab.ui.container.Panel
        Grid_Pattern                  matlab.ui.container.GridLayout
        Tabs_Pattern                  matlab.ui.container.TabGroup
        Tab1_Contour                  matlab.ui.container.Tab
        Grid_Contour                  matlab.ui.container.GridLayout
        Axes_Contour                  matlab.ui.control.UIAxes
        Tab2_Circular                 matlab.ui.container.Tab
        Grid_Circular                 matlab.ui.container.GridLayout
        Axes_Circular                 matlab.ui.control.UIAxes
        Tab3_Spherical                matlab.ui.container.Tab
        Grid_Spherical                matlab.ui.container.GridLayout
        Axes_Spherical                matlab.ui.control.UIAxes
        Tab4_3D                       matlab.ui.container.Tab
        Grid_3D                       matlab.ui.container.GridLayout
        Axes_3D                       matlab.ui.control.UIAxes
        Panel_PlotControls            matlab.ui.container.Panel
        Grid_PlotCtrl                 matlab.ui.container.GridLayout
        DViewpresetDropDown           matlab.ui.control.DropDown
        DViewpresetDropDownLabel      matlab.ui.control.Label
        DviewElSpinner                matlab.ui.control.Spinner
        DviewElSpinnerLabel           matlab.ui.control.Label
        DViewAzSpinner                matlab.ui.control.Spinner
        DViewAzSpinnerLabel           matlab.ui.control.Label
        Input_Plot_Cstep              matlab.ui.control.Spinner
        ColorbarstepLabel             matlab.ui.control.Label
        Input_Plot_Cmax               matlab.ui.control.Spinner
        ColorbarmaxLabel              matlab.ui.control.Label
        Input_Plot_Cmin               matlab.ui.control.Spinner
        ColorbarminLabel              matlab.ui.control.Label
        Input_Cut_Value               matlab.ui.control.Spinner
        CutvalueLabel                 matlab.ui.control.Label
        DropDown_CutType              matlab.ui.control.DropDown
        CuttypeDropDownLabel          matlab.ui.control.Label
        DropDown_Component            matlab.ui.control.DropDown
        ComponentLabel                matlab.ui.control.Label
        Tab1_Panel1                   matlab.ui.container.Panel
        T1P1_Grid                     matlab.ui.container.GridLayout
        RotationLabel                 matlab.ui.control.Label
        Button_Rotation               matlab.ui.control.Button
        TargetDropDown_2              matlab.ui.control.DropDown
        TargetDropDown_2Label         matlab.ui.control.Label
        TargetDropDown                matlab.ui.control.DropDown
        TargetDropDownLabel           matlab.ui.control.Label
        SourceDropDown_2              matlab.ui.control.DropDown
        SourceDropDown_2Label         matlab.ui.control.Label
        SourceDropDown                matlab.ui.control.DropDown
        SourceLabel                   matlab.ui.control.Label
        DropDown_Orientation          matlab.ui.control.DropDown
        ComputeCoverageButton         matlab.ui.control.Button
        Label_MaxInputE               matlab.ui.control.Label
        Label_MaxGain                 matlab.ui.control.Label
        DominantPolLabel              matlab.ui.control.Label
        DropDown_Step                 matlab.ui.control.DropDown
        Input_Distance                matlab.ui.control.Spinner
        DistanceLabel                 matlab.ui.control.Label
        DropDown_Pt                   matlab.ui.control.DropDown
        Input_Pt                      matlab.ui.control.Spinner
        TxPowerdBLabel                matlab.ui.control.Label
        Input_Rw                      matlab.ui.control.Spinner
        IncidentWaveARRw_dBLabel      matlab.ui.control.Label
        Input_Loss                    matlab.ui.control.Spinner
        LossidBLabel                  matlab.ui.control.Label
        Button_ExportOutput           matlab.ui.control.Button
        Button_ExportInput            matlab.ui.control.Button
        Input_Label                   matlab.ui.control.Label
        Button_Process_Single         matlab.ui.control.Button
        Button_Load_Single            matlab.ui.control.Button
        Input_PatternField            matlab.ui.control.EditField
        InputPatternLabel             matlab.ui.control.Label
        DropDown_Format               matlab.ui.control.DropDown
        FormatLabel                   matlab.ui.control.Label
        Tab2_Batch                    matlab.ui.container.Tab
        Tab2_Grid                     matlab.ui.container.GridLayout
        Tree2                         matlab.ui.container.CheckBoxTree
        Node_2                        matlab.ui.container.TreeNode
        Node2_2                       matlab.ui.container.TreeNode
        Node3_2                       matlab.ui.container.TreeNode
        Node4_2                       matlab.ui.container.TreeNode
        Tab2_Panel1                   matlab.ui.container.Panel
        T2P1_Grid                     matlab.ui.container.GridLayout
        DropDown_Orientation_2        matlab.ui.control.DropDown
        Input_Distance_2              matlab.ui.control.Spinner
        DistanceLabel_2               matlab.ui.control.Label
        DropDown_Pt_2                 matlab.ui.control.DropDown
        Input_Pt_2                    matlab.ui.control.Spinner
        TxPowerdBLabel_2              matlab.ui.control.Label
        Input_Rw_2                    matlab.ui.control.Spinner
        IncidentWaveARRw_dBLabel_2    matlab.ui.control.Label
        Input_Loss_2                  matlab.ui.control.Spinner
        LossidBLabel_2                matlab.ui.control.Label
        Button_ExportOutput_2         matlab.ui.control.Button
        Button_ExportInput_2          matlab.ui.control.Button
        Input_Label_2                 matlab.ui.control.Label
        Button_Process_Batch          matlab.ui.control.Button
        Button_Load_Batch             matlab.ui.control.Button
        Input_PatternField_Batch      matlab.ui.control.EditField
        InputFolderLabel              matlab.ui.control.Label
        DropDown_Format_2             matlab.ui.control.DropDown
        FormatLabel_2                 matlab.ui.control.Label
        Tab3_Coverage                 matlab.ui.container.Tab
        Tab3_Grid                     matlab.ui.container.GridLayout
        UITable                       matlab.ui.control.Table
        Tree                          matlab.ui.container.CheckBoxTree
        Node                          matlab.ui.container.TreeNode
        Node2                         matlab.ui.container.TreeNode
        Node3                         matlab.ui.container.TreeNode
        Node4                         matlab.ui.container.TreeNode
        Tab3_Panel1                   matlab.ui.container.Panel
        T3P1_Grid                     matlab.ui.container.GridLayout
        Button_Clear                  matlab.ui.control.Button
        Spinner_coneAng               matlab.ui.control.Spinner
        CongAngleLabel                matlab.ui.control.Label
        Spinner_conePH                matlab.ui.control.Spinner
        ConeLabel                     matlab.ui.control.Label
        Spinner_coneTH                matlab.ui.control.Spinner
        Cone0Label                    matlab.ui.control.Label
        Spinner_threshStep            matlab.ui.control.Spinner
        StepLabel                     matlab.ui.control.Label
        Spinner_threshMax             matlab.ui.control.Spinner
        ThreshMindBLabel_2            matlab.ui.control.Label
        Spinner_threshMin             matlab.ui.control.Spinner
        ThreshMindBLabel              matlab.ui.control.Label
        DropDown_covOrientation       matlab.ui.control.DropDown
        ButtonGroup_Coverage          matlab.ui.container.ButtonGroup
        Button_Spherical              matlab.ui.control.RadioButton
        Button_Conical                matlab.ui.control.RadioButton
        Button_ExportOutput_Coverage  matlab.ui.control.Button
        Button_Process_Coverage       matlab.ui.control.Button
        Button_Load_Coverage          matlab.ui.control.Button
        Input_PatternField_Coverage   matlab.ui.control.EditField
        GainPatternLabel              matlab.ui.control.Label
        UIAxes                        matlab.ui.control.UIAxes
        Tab4_Combine                  matlab.ui.container.Tab
        Tab2_Grid_2                   matlab.ui.container.GridLayout
        Tree2_2                       matlab.ui.container.CheckBoxTree
        Node_3                        matlab.ui.container.TreeNode
        Node2_3                       matlab.ui.container.TreeNode
        Node3_3                       matlab.ui.container.TreeNode
        Node4_3                       matlab.ui.container.TreeNode
        Tab2_Panel1_2                 matlab.ui.container.Panel
        T2P1_Grid_2                   matlab.ui.container.GridLayout
        ButtonGroup_CombineMethod     matlab.ui.container.ButtonGroup
        RadioButton_Method3           matlab.ui.control.RadioButton
        RadioButton_Method2           matlab.ui.control.RadioButton
        RadioButton_Method1           matlab.ui.control.RadioButton
        Metode1CombinePowersEfieldsLabel  matlab.ui.control.Label
        Button_ExportCombined         matlab.ui.control.Button
        Button_Combine                matlab.ui.control.Button
        Button_LoadCombine            matlab.ui.control.Button
        Button_ClearCombine           matlab.ui.control.Button
        Table_MaskCombine             matlab.ui.control.Table
        Label_MaskRemainder           matlab.ui.control.Label
        Label_MaskPartitionAxis       matlab.ui.control.Label
        DropDown_MaskPartitionAxis    matlab.ui.control.DropDown
        Combine_Viz_Panel             matlab.ui.container.Panel
    end

    
    properties (Access = private)
        pax matlab.graphics.axis.PolarAxes % Polar Axes (cut — line)
        % --- XGTD processing state (lib/+io, lib/+proc) ---
        projRoot (1, :) char = ''
        P_single = []
        R_single = []
        fzList cell = {}
        batchResults table = table()
        P_cov = []
        R_cov = []
        combineFiles cell = {}
        lastCombinedQ = []              % latest pattern from Combine Patterns (for Export)
        combineLabelSeq (1, 1) double = 0   % unique suffix for in-session 'Combined #n' entries
        P_combine_list cell = {}
        R_combine_list cell = {}
        coverageList cell = {}   % each element: struct(label,path,P,R)
        camBusy (1,1) logical = false
        suppressViewSpinner (1,1) logical = false
        lastViewSyncT = []              % uint64 from tic; [] until first throttle reset
        combinePhiEdges double = []
        combineThetaEdges double = []
        lastCameraAxesHandle         % axes whose view drives Az/El sync (3D pattern vs spherical)
        perfEnabled (1,1) logical = true    % when true: perfLog → Command Window + base workspace APA_perfHistory / APA_perfLast
        suppressOrientationPreset (1,1) logical = false   % avoid recursive Orientation/Source callbacks
        suppressPlotControlCallbacks (1,1) logical = false   % block Cmin/Cmax/Cstep ValueChanged during batch refresh
        displayCmap256 double = []          % lazy turbo/jet RGB table for pattern axes
        lastRadOverlayKeySpherical (1, 1) double = NaN
        lastRadOverlayKey3D (1, 1) double = NaN
        contourPlotCache struct = struct('key', '', 'PhiPlot', [], 'ThetaPlot', [], 'fldPlot', [])
        thetaPhiSortIdx double = []        % reuse sort order for input/output tables (same θ–φ grid)
        lastCombinePreviewSig (1, :) char = ''   % skip redundant combine preview rebuilds
        maxUITableDisplayRows (1, 1) double = 4000    % cap uit-able rows (UITable layout dominates drawnow); Export uses full grid
    end
    
    % Callbacks that handle component events
    methods (Access = private)

        function startupFcn(app)
            tStartupWall = tic;
            app.pax = polaraxes(app.Grid_Polar);
            cla(app.pax,"reset");
            reset(app.pax);
            app.pax.ThetaZeroLocation='top';
            app.pax.ThetaDir = 'clockwise';
            
            app.Table_DataIn.RowName = 'numbered';
            app.Table_DataOut.RowName = 'numbered';

            % Single fileparts: directory containing this class file (xgtd_project/)
            app.projRoot = fileparts(mfilename('fullpath'));
            addpath(genpath(fullfile(app.projRoot, 'lib')));

            delete(app.Node2); delete(app.Node3); delete(app.Node4);
            app.Node.Text = 'Coverage patterns';

            app.Button_Load_Single.ButtonPushedFcn = @(s,e) app.onLoadSingle();
            app.Button_Process_Single.ButtonPushedFcn = @(s,e) app.onProcessSingle();
            app.Button_ExportInput.ButtonPushedFcn = @(s,e) app.onExportInput();
            app.Button_ExportOutput.ButtonPushedFcn = @(s,e) app.onExportOutput();
            app.DropDown_Component.ValueChangedFcn = @(s,e) app.onComponentChanged();
            app.Button_Load_Batch.ButtonPushedFcn = @(s,e) app.onLoadBatch();
            app.Button_Process_Batch.ButtonPushedFcn = @(s,e) app.onProcessBatch();
            app.Button_ExportOutput_2.ButtonPushedFcn = @(s,e) app.onExportBatchSummary();
            app.Button_Load_Coverage.ButtonPushedFcn = @(s,e) app.onLoadCoverage();
            app.Button_Process_Coverage.ButtonPushedFcn = @(s,e) app.onProcessCoverage();
            app.Button_ExportOutput_Coverage.ButtonPushedFcn = @(s,e) app.onExportCoverage();
            app.ButtonGroup_Coverage.SelectionChangedFcn = @(s,e) app.onCoverageModeChanged();
            app.Button_Clear.ButtonPushedFcn = @(s,e) app.onClearCoverage();
            app.Button_LoadCombine.ButtonPushedFcn = @(s,e) app.onLoadCombine();
            app.Button_ClearCombine.ButtonPushedFcn = @(s,e) app.onClearCombine();
            app.Button_Combine.ButtonPushedFcn = @(s,e) app.onCombinePatterns();
            app.Button_ExportCombined.ButtonPushedFcn = @(s,e) app.onExportCombined();
            app.DropDown_CutType.ValueChangedFcn = @(s,e) app.onCutControlChanged();
            app.Input_Cut_Value.ValueChangedFcn = @(s,e) app.onCutControlChanged();
            app.Input_Plot_Cmin.ValueChangedFcn = @(s,e) app.onPlotColorControlsChanged();
            app.Input_Plot_Cmax.ValueChangedFcn = @(s,e) app.onPlotColorControlsChanged();
            app.Input_Plot_Cstep.ValueChangedFcn = @(s,e) app.onPlotColorControlsChanged();
            app.DViewAzSpinner.ValueChangedFcn = @(s,e) app.on3DViewSpinnersChanged();
            app.DviewElSpinner.ValueChangedFcn = @(s,e) app.on3DViewSpinnersChanged();
            app.DViewpresetDropDown.ValueChangedFcn = @(s,e) app.on3DPresetDropdownChanged();
            app.DropDown_output.ValueChangedFcn = @(s,e) app.onDropDownOutputViewChanged();
            app.ComputeCoverageButton.ButtonPushedFcn = @(s,e) app.onComputeCoverageNavigate();
            app.Tree.SelectionChangedFcn = @(src, evt) app.onCoverageTreeSelection(evt);
            app.onCoverageModeChanged();
            app.syncCutSpinnerLimits();
            try
                app.Tabs_Pattern.SelectionChangedFcn = @(~,~) app.onPatternSubtabChanged();
            catch
            end
            try
                app.Tabs_Cuts.SelectionChangedFcn = @(~,~) app.onCutsTabsSelectionChanged();
            catch
            end
            app.attach3DCameraListeners();
            app.lastCameraAxesHandle = app.Axes_3D;
            try
                app.UIFigure.WindowButtonUpFcn = @(src, evt) app.onWindowButtonUp(src, evt);
                app.UIFigure.WindowButtonMotionFcn = @(src, evt) app.onWindowMotionSyncView(src, evt);
            catch
            end
            try
                rotate3d(app.Axes_3D, 'on');
                rotate3d(app.Axes_Spherical, 'on');
            catch
            end
            try
                app.camBusy = true;
                c = onCleanup(@() app.releaseCamBusy());
                az0 = app.DViewAzSpinner.Value;
                el0 = app.DviewElSpinner.Value;
                view(app.Axes_3D, az0, el0);
                view(app.Axes_Spherical, az0, el0);
                app.lastCameraAxesHandle = app.Axes_3D;
            catch
            end
            app.DropDown_Orientation.ValueChangedFcn = @(s,e) app.onOrientationPresetChanged();
            app.SourceDropDown.ValueChangedFcn = @(s,e) app.onSourceAngleControlsChanged();
            app.SourceDropDown_2.ValueChangedFcn = @(s,e) app.onSourceAngleControlsChanged();
            app.Button_Rotation.ButtonPushedFcn = @(s,e) app.onRotatePattern();
            delete(app.Node2_3); delete(app.Node3_3); delete(app.Node4_3);
            app.Node_3.Text = 'Loaded patterns';
            app.ButtonGroup_CombineMethod.SelectionChangedFcn = @(~,~) app.onCombineMethodChanged();
            app.Table_MaskCombine.CellEditCallback = @(s, e) app.onCombineMaskCellEdited(e);
            app.DropDown_MaskPartitionAxis.ValueChangedFcn = @(~,~) app.refreshCombineMaskTable();
            optsItems = app.DropDown_MaskPartitionAxis.Items;
            if ~any(strcmp(app.DropDown_MaskPartitionAxis.Value, optsItems))
                app.DropDown_MaskPartitionAxis.Value = optsItems{end};
            end
            try
                app.Tree2_2.CheckedNodesChangedFcn = @(~,~) app.onCombineTreeCheckedChanged();
            catch
            end
            app.onCombineMethodChanged();
            try
                app.TabsData.SelectionChangedFcn = @(~,~) app.onDataTabsSelectionChanged();
            catch
            end
            if app.perfEnabled
                app.perfLogTotal('startupFcn_full_UI_setup', toc(tStartupWall));
            end
        end

        function refreshCombineTree(app, varargin)
            selectAll = false;
            ensureChecked = [];
            for ka = 1:numel(varargin)
                o = varargin{ka};
                if isempty(o) || ~isstruct(o)
                    continue
                end
                if isfield(o, 'selectAll')
                    selectAll = logical(o.selectAll);
                end
                if isfield(o, 'ensureCheckedIndices')
                    ec = o.ensureCheckedIndices;
                    if isnumeric(ec)
                        ensureChecked = unique([ensureChecked(:)', ec(:)']);
                    end
                end
            end
            ch = app.Node_3.Children;
            checkedIdx = [];
            hadPatternLeaves = false;
            for k = 1:numel(ch)
                nd = ch(k);
                if ~isgraphics(nd)
                    continue
                end
                ii = app.combineLeafIndex(nd);
                if ~isempty(ii) && ii >= 1
                    hadPatternLeaves = true;
                end
            end
            if selectAll
                checkedIdx = 1:numel(app.combineFiles);
            else
                try
                    cn = app.Tree2_2.CheckedNodes;
                    for k = 1:numel(cn)
                        nd = cn(k);
                        ii = app.combineLeafIndex(nd);
                        if ~isempty(ii) && ii >= 1 && ii <= numel(app.combineFiles)
                            checkedIdx(end + 1) = ii; %#ok<AGROW>
                        end
                    end
                catch
                end
                checkedIdx = sort(unique(checkedIdx));
                if isempty(checkedIdx) && (~hadPatternLeaves || isempty(ch))
                    checkedIdx = 1:numel(app.combineFiles);
                end
            end
            if ~isempty(ensureChecked)
                checkedIdx = sort(unique([checkedIdx(:)', ensureChecked(:)']));
            end
            for k = 1:numel(ch)
                delete(ch(k));
            end
            toCheck = [];
            for i = 1:numel(app.combineFiles)
                [~, baseName, ext] = fileparts(app.combineFiles{i});
                leaf = uitreenode(app.Node_3);
                if isempty(ext) && strncmp(baseName, 'Combined ', 10)
                    leaf.Text = baseName;
                else
                    leaf.Text = [baseName ext];
                end
                app.assignCombineLeafIndex(leaf, i);
                if ismember(i, checkedIdx)
                    toCheck = [toCheck, leaf]; %#ok<AGROW>
                end
            end
            try
                app.Tree2_2.CheckedNodes = toCheck;
            catch
            end
            try
                expand(app.Node_3);
            catch
            end
        end

        function onDataTabsSelectionChanged(app)
            if isempty(app.P_single) || isempty(app.R_single)
                return;
            end
            app.syncVisibleDataTables();
        end

        function idx = getCombineCheckedIndices(app)
            idx = [];
            try
                cn = app.Tree2_2.CheckedNodes;
                for k = 1:numel(cn)
                    ii = app.combineLeafIndex(cn(k));
                    if ~isempty(ii) && ii >= 1 && ii <= numel(app.combineFiles)
                        idx(end + 1) = ii; %#ok<AGROW>
                    end
                end
            catch
            end
            idx = sort(unique(idx));
        end

        function ii = combineLeafIndex(~, nd)
            ii = [];
            if nargin < 2 || ~isgraphics(nd)
                return
            end
            if isprop(nd, 'NodeData')
                v = nd.NodeData;
                if isnumeric(v) && isscalar(v) && isfinite(v)
                    ii = double(v);
                    return
                end
            end
            if isprop(nd, 'UserData')
                v = nd.UserData;
                if isnumeric(v) && isscalar(v) && isfinite(v)
                    ii = double(v);
                end
            end
        end

        function assignCombineLeafIndex(~, leaf, idxNum)
            if isprop(leaf, 'NodeData')
                leaf.NodeData = idxNum;
            elseif isprop(leaf, 'UserData')
                leaf.UserData = idxNum;
            end
        end

        function onCombineTreeCheckedChanged(app)
            app.syncCombineMethodDescriptionLabel();
            app.refreshCombineMaskTable();
        end

        function applyPolarAxesConvention(app)
            if ~isgraphics(app.pax)
                return
            end
            try
                app.pax.ThetaZeroLocation = 'top';
                app.pax.ThetaDir = 'clockwise';
            catch
            end
        end

        function tf = viewsAzElClose(~, az1, el1, az2, el2)
            if ~(all(isfinite([az1, el1, az2, el2])))
                tf = true;
                return
            end
            dAz = abs(mod((az1 - az2) + 180, 360) - 180);
            tf = dAz < 0.45 && abs(el1 - el2) < 0.45;
        end

        function syncPartner3DViewFromLeader(app)
            if app.camBusy || app.suppressViewSpinner
                return
            end
            axLead = app.lastCameraAxesHandle;
            if ~isgraphics(axLead)
                axLead = app.Axes_3D;
            end
            if ~(isequal(axLead, app.Axes_3D) || isequal(axLead, app.Axes_Spherical))
                return
            end
            try
                [az1, el1] = view(axLead);
                if ~(isfinite(az1) && isfinite(el1))
                    return
                end
                if isequal(axLead, app.Axes_3D)
                    tgt = app.Axes_Spherical;
                else
                    tgt = app.Axes_3D;
                end
                [az2, el2] = view(tgt);
                if app.viewsAzElClose(az1, el1, az2, el2)
                    return
                end
                app.camBusy = true;
                c = onCleanup(@() app.releaseCamBusy());
                view(tgt, az1, el1);
            catch
            end
        end

        function refreshCombineMaskTable(app)
            idxSel = app.getCombineCheckedIndices();
            nf = numel(idxSel);
            showMask = app.RadioButton_Method3.Value && nf >= 2;
            app.Table_MaskCombine.Visible = app.onOff(showMask);
            app.Label_MaskRemainder.Visible = app.onOff(showMask);
            app.DropDown_MaskPartitionAxis.Visible = app.onOff(showMask);
            app.Label_MaskPartitionAxis.Visible = app.onOff(showMask);
            if ~showMask || nf < 2
                app.Label_MaskRemainder.Text = '';
                app.combinePhiEdges = [];
                app.combineThetaEdges = [];
                if numel(app.P_combine_list) >= 1
                    app.refreshCombinePreviewPlots();
                end
                return
            end
            mode = app.maskPartitionMode();
            switch mode
                case 'phi_only'
                    app.combinePhiEdges = linspace(0, 360, nf + 1)';
                    app.combineThetaEdges = [];
                case 'theta_only'
                    app.combineThetaEdges = linspace(0, 180, nf + 1)';
                    app.combinePhiEdges = [];
                case 'custom'
                    app.combinePhiEdges = [];
                    app.combineThetaEdges = [];
                    D = app.Table_MaskCombine.Data;
                    if ~isempty(D) && size(D, 1) == nf && size(D, 2) >= 5
                        app.syncCombineMaskPatternNamesOnly();
                    else
                        app.Table_MaskCombine.Data = app.buildDefaultCustomMaskRows(idxSel);
                    end
            end
            if ~strcmp(mode, 'custom')
                app.syncCombineMaskTableDataFromEdges();
            end
            app.updateCombineRemainderLabel();
            app.refreshCombinePreviewPlots();
        end

        function mode = maskPartitionMode(app)
            v = app.DropDown_MaskPartitionAxis.Value;
            if strcmp(v, 'Theta / polar only')
                mode = 'theta_only';
            elseif strcmp(v, 'Phi / azimuth only')
                mode = 'phi_only';
            elseif strcmp(v, 'Custom sectors (free table)')
                mode = 'custom';
            else
                mode = 'custom';
            end
        end

        function updateCombineRemainderLabel(app)
            nf = numel(app.getCombineCheckedIndices());
            if nf < 2 || ~app.RadioButton_Method3.Value
                app.Label_MaskRemainder.Text = '';
                return
            end
            switch app.maskPartitionMode()
                case 'custom'
                    app.Label_MaskRemainder.Text = ...
                        ['Custom sectors: independent θ/φ bounds per row (cap + remainder slices, etc.). ', ...
                        'Overlapping θ–φ rectangles are rejected. combinePatterns assigns first matching row per direction; gaps use the last pattern.'];
                otherwise
                    app.Label_MaskRemainder.Text = ...
                        'Phi-only / Theta-only modes: contiguous bands; editing a boundary shifts adjacent sectors.';
            end
        end

        function syncCombineMethodDescriptionLabel(app)
            if app.RadioButton_Method1.Value
                app.Metode1CombinePowersEfieldsLabel.Text = ...
                    'Coherent combine: weighted sum of Eθ and Eφ (equal weights).';
            elseif app.RadioButton_Method2.Value
                app.Metode1CombinePowersEfieldsLabel.Text = ...
                    'Best source per direction (coming soon); coherent sum used as fallback.';
            else
                app.Metode1CombinePowersEfieldsLabel.Text = ...
                    ['Regional masking: choose slicing (dropdown). Each checked pattern gets a θ–φ sector; Combine merges by sector.'];
            end
            nFiles = numel(app.combineFiles);
            nSel = numel(app.getCombineCheckedIndices());
            if isempty(app.combineFiles)
                app.Metode1CombinePowersEfieldsLabel.Text = ...
                    [app.Metode1CombinePowersEfieldsLabel.Text, ' ', sprintf('%d file(s) loaded.', 0)];
            else
                app.Metode1CombinePowersEfieldsLabel.Text = ...
                    [app.Metode1CombinePowersEfieldsLabel.Text, ' ', ...
                    sprintf('%d file(s) loaded, %d selected for combine.', nFiles, nSel)];
            end
        end

        function onCombineMethodChanged(app)
            app.syncCombineMethodDescriptionLabel();
            app.refreshCombineMaskTable();
        end

        function onCombineMaskCellEdited(app, evt)
            if isempty(evt.Indices)
                return
            end
            if ~app.RadioButton_Method3.Value || numel(app.getCombineCheckedIndices()) < 2
                return
            end
            try
                if isprop(evt, 'EditData')
                    nv = evt.EditData;
                elseif isprop(evt, 'NewData')
                    nv = evt.NewData;
                else
                    return
                end
                val = app.scalarDeg(nv);
            catch
                if ~strcmp(app.maskPartitionMode(), 'custom')
                    app.syncCombineMaskTableDataFromEdges();
                end
                return
            end
            r = evt.Indices(1);
            c = evt.Indices(2);
            mode = app.maskPartitionMode();
            if strcmp(mode, 'custom')
                snap = app.snapshotMaskTable(app.Table_MaskCombine.Data);
                D = snap;
                if iscell(D)
                    D{r, c} = val;
                else
                    D(r, c) = val;
                end
                app.Table_MaskCombine.Data = D;
                [okVal, msgVal] = app.validateCustomMaskTableNumeric();
                if ~okVal
                    app.Table_MaskCombine.Data = snap;
                    uialert(app.UIFigure, msgVal, 'Regional mask');
                    return
                end
            elseif strcmp(mode, 'phi_only')
                app.applyCombinePhiEdgeEdit(r, c, val);
            elseif strcmp(mode, 'theta_only')
                app.applyCombineThetaEdgeEdit(r, c, val);
            end
            if ~strcmp(mode, 'custom')
                app.syncCombineMaskTableDataFromEdges();
            end
            if app.RadioButton_Method3.Value && numel(app.getCombineCheckedIndices()) >= 2
                app.refreshCombinePreviewPlots();
            end
        end

        function applyCombinePhiEdgeEdit(app, r, c, val)
            nf = numel(app.getCombineCheckedIndices());
            e = app.combinePhiEdges(:);
            if numel(e) ~= nf + 1
                e = linspace(0, 360, nf + 1)';
            end
            minSep = 0.25;
            if c == 4 && r >= 2
                e(r) = val;
            elseif c == 5 && r <= nf - 1
                e(r + 1) = val;
            end
            e(1) = 0;
            e(end) = 360;
            e = app.clampMonotoneInterior(e, minSep);
            app.combinePhiEdges = e;
        end

        function applyCombineThetaEdgeEdit(app, r, c, val)
            nf = numel(app.getCombineCheckedIndices());
            e = app.combineThetaEdges(:);
            if numel(e) ~= nf + 1
                e = linspace(0, 180, nf + 1)';
            end
            minSep = 0.25;
            if c == 2 && r >= 2
                e(r) = val;
            elseif c == 3 && r <= nf - 1
                e(r + 1) = val;
            end
            e(1) = 0;
            e(end) = 180;
            e = app.clampMonotoneInterior(e, minSep);
            app.combineThetaEdges = e;
        end

        function v = clampMonotoneInterior(~, e, minSep)
            v = e(:);
            for pass = 1:8
                for k = 2:numel(v) - 1
                    lo = v(k - 1) + minSep;
                    hi = v(k + 1) - minSep;
                    if hi < lo
                        hi = lo;
                    end
                    v(k) = min(max(v(k), lo), hi);
                end
            end
        end

        function syncCombineMaskTableDataFromEdges(app)
            idxSel = app.getCombineCheckedIndices();
            nf = numel(idxSel);
            if nf < 2
                return
            end
            mode = app.maskPartitionMode();
            if strcmp(mode, 'custom')
                app.syncCombineMaskPatternNamesOnly();
                return
            end
            rows = cell(nf, 5);
            switch mode
                case 'phi_only'
                    e = app.combinePhiEdges(:);
                    if numel(e) ~= nf + 1
                        e = linspace(0, 360, nf + 1)';
                        app.combinePhiEdges = e;
                    end
                    for ki = 1:nf
                        i = idxSel(ki);
                        [~, nm] = fileparts(app.combineFiles{i});
                        rows{ki, 1} = nm;
                        rows{ki, 2} = 0;
                        rows{ki, 3} = 180;
                        rows{ki, 4} = e(ki);
                        rows{ki, 5} = e(ki + 1);
                    end
                case 'theta_only'
                    e = app.combineThetaEdges(:);
                    if numel(e) ~= nf + 1
                        e = linspace(0, 180, nf + 1)';
                        app.combineThetaEdges = e;
                    end
                    for ki = 1:nf
                        i = idxSel(ki);
                        [~, nm] = fileparts(app.combineFiles{i});
                        rows{ki, 1} = nm;
                        rows{ki, 2} = e(ki);
                        rows{ki, 3} = e(ki + 1);
                        rows{ki, 4} = 0;
                        rows{ki, 5} = 360;
                    end
                otherwise
                    error('APA:maskSync', 'Unsupported regional mask mode.');
            end
            app.Table_MaskCombine.Data = rows;
        end

        function rows = buildDefaultCustomMaskRows(app, idxSel)
            nf = numel(idxSel);
            rows = cell(nf, 5);
            thCap = min(30, max(5, 180 / max(nf + 1, 3)));
            thLoRem = min(thCap + 1, 179);
            pe = linspace(0, 360, nf)';
            for ki = 1:nf
                i = idxSel(ki);
                [~, nm] = fileparts(app.combineFiles{i});
                rows{ki, 1} = nm;
                if ki == 1
                    rows{ki, 2} = 0;
                    rows{ki, 3} = thCap;
                    rows{ki, 4} = 0;
                    rows{ki, 5} = 360;
                else
                    rows{ki, 2} = thLoRem;
                    rows{ki, 3} = 180;
                    rows{ki, 4} = pe(ki - 1);
                    rows{ki, 5} = pe(ki);
                end
            end
        end

        function syncCombineMaskPatternNamesOnly(app)
            idxSel = app.getCombineCheckedIndices();
            nf = numel(idxSel);
            D = app.Table_MaskCombine.Data;
            if isempty(D) || size(D, 1) ~= nf || size(D, 2) < 5
                return
            end
            if ~iscell(D)
                return
            end
            for ki = 1:nf
                i = idxSel(ki);
                [~, nm] = fileparts(app.combineFiles{i});
                D{ki, 1} = nm;
            end
            app.Table_MaskCombine.Data = D;
        end

        function [thetaBands, phiBands] = readCombineMaskBands(app, nPat)
            thetaBands = zeros(nPat, 2);
            phiBands = zeros(nPat, 2);
            D = app.Table_MaskCombine.Data;
            assert(size(D, 1) >= nPat && size(D, 2) >= 5, ...
                'APA:maskTable', 'Mask table must list %d patterns.', nPat);
            for r = 1:nPat
                thetaBands(r, :) = [app.scalarDeg(app.maskTblCell(D, r, 2)), app.scalarDeg(app.maskTblCell(D, r, 3))];
                phiBands(r, :) = [app.scalarDeg(app.maskTblCell(D, r, 4)), app.scalarDeg(app.maskTblCell(D, r, 5))];
            end
            if any(thetaBands(:, 1) > thetaBands(:, 2))
                error('APA:maskTheta', 'Each θ max must be ≥ θ min.');
            end
        end

        function snap = snapshotMaskTable(~, D)
            if iscell(D)
                snap = cell(size(D));
                for ii = 1:numel(D)
                    snap{ii} = D{ii};
                end
            else
                snap = D;
            end
        end

        function [ok, msg] = validateCustomMaskTableNumeric(app)
            ok = true;
            msg = '';
            nf = numel(app.getCombineCheckedIndices());
            try
                app.readCombineMaskBands(nf);
            catch ME
                ok = false;
                msg = ME.message;
                return
            end
        end

        function x = scalarDeg(~, v)
            if isnumeric(v)
                x = double(v);
            elseif ischar(v) || isstring(v)
                s = char(strtrim(v));
                s = strrep(s, char(176), '');
                s = strrep(s, '°', '');
                s = regexprep(s, '\s', '');
                x = str2double(s);
            else
                x = NaN;
            end
            if ~(isfinite(x) && isscalar(x))
                error('APA:maskParse', 'Enter numeric θ and φ values (degrees).');
            end
        end

        function v = maskTblCell(~, D, r, c)
            if iscell(D)
                v = D{r, c};
            else
                v = D(r, c);
            end
        end

        function s = onOff(~, tf)
            if tf
                s = 'on';
            else
                s = 'off';
            end
        end

        function onComputeCoverageNavigate(app)
            if isempty(app.P_single)
                uialert(app.UIFigure, 'Load a pattern first.', 'Coverage');
                return
            end
            if isempty(app.R_single)
                try
                    app.onProcessSingle();
                catch ME
                    uialert(app.UIFigure, ME.message, 'Process');
                    return
                end
            end
            app.TabGroup.SelectedTab = app.Tab3_Coverage;
            app.Input_PatternField_Coverage.Value = app.Input_PatternField.Value;
            app.P_cov = app.P_single;
            app.R_cov = app.R_single;
        end

        function onCoverageTreeSelection(app, evt)
            nodes = evt.SelectedNodes;
            if isempty(nodes), return; end
            nd = nodes(1);
            idx = nd.UserData;
            if isempty(idx) || ~isnumeric(idx) || idx < 1 || idx > numel(app.coverageList)
                return
            end
            ent = app.coverageList{idx};
            app.Input_PatternField_Coverage.Value = ent.path;
            app.P_cov = ent.P;
            app.R_cov = ent.R;
        end

        function refreshCoverageTree(app)
            ch = app.Node.Children;
            for k = 1:numel(ch)
                delete(ch(k));
            end
            for i = 1:numel(app.coverageList)
                ent = app.coverageList{i};
                n = uitreenode(app.Node);
                n.Text = ent.label;
                n.UserData = i;
            end
        end

        function onLoadSingle(app)
            prev = pwd;
            c = onCleanup(@() cd(prev));
            try
                cd(app.projRoot);
            catch
            end
            if app.perfEnabled
                tLoadSessionWall = tic;
            end
            [fn, fp] = uigetfile( ...
                {'*.fz;*.uan;*.ffs;*.ffd;*.ffe;*.out', 'Antenna patterns'; '*.*', 'All Files'}, ...
                'Select pattern file');
            if app.perfEnabled
                app.perfLog('onLoadSingle_uigetfile_dialog_wall', toc(tLoadSessionWall));
            end
            if isnumeric(fn), return; end
            fz = fullfile(fp, fn);
            tGrandWall = tic;
            app.Input_PatternField.Value = fz;
            app.Input_Label.Text = 'Loading…';
            try
                drawnow expose;
            catch
                drawnow
            end
            try
                tWallLoad = tic;
                tLd = tic;
                app.P_single = io.loadPattern(fz);
                app.clearContourPlotCache();
                app.perfLog('loadPattern', toc(tLd));
                mg = app.P_single.meta.header.maximum_gain;
                app.Input_Label.Text = sprintf('Loaded: %s  (maximum_gain %.3f dB)', fn, mg);
                app.perfLog('onLoadSingle_after_load_until_Process_UI_start', toc(tWallLoad));
            catch ME
                uialert(app.UIFigure, ME.message, 'Load error');
                app.Input_Label.Text = '';
                return
            end
            try
                app.onProcessSingle();
            catch ME
                uialert(app.UIFigure, ME.message, 'Process error');
            end
            app.perfLog('onLoadSingle_segment_load_through_process_return', toc(tWallLoad));
            if app.perfEnabled
                app.perfLogTotal('TOTAL_after_file_pick_through_pipeline_blocking_UI', toc(tGrandWall), 'WorkspacePrimary', false);
                app.perfLogTotal('TOTAL_Load_click_through_blocking_UI_includes_dialog', toc(tLoadSessionWall), 'WorkspacePrimary', true);
            end
        end

        function onProcessSingle(app, varargin)
            if isempty(app.P_single)
                uialert(app.UIFigure, 'Load a pattern file first.', 'Process');
                return
            end
            skipPrincipalOrientation = nargin >= 2 && logical(varargin{1});
            tPr = tic;
            app.R_single = proc.processPattern(app.P_single, struct);
            app.perfLog('processPattern', toc(tPr));
            prevSuppress = app.suppressPlotControlCallbacks;
            app.suppressPlotControlCallbacks = true;
            cCleanup = onCleanup(@() app.restorePlotControlSuppress(prevSuppress)); %#ok<NASGU>
            if app.perfEnabled
                tUiPipe = tic;
            end
            app.populateBothDataTablesDisplay();
            tLb = tic;
            app.Label_MaxGain.Text = sprintf('Max Total Gain:\n %.2f dB', app.R_single.maxGain_dB);
            mxEth = max(abs(app.P_single.Eth(:)));
            mxEph = max(abs(app.P_single.Eph(:)));
            app.Label_MaxInputE.Text = sprintf('Peak |Eθ|/|Eφ|:\n %.2e / %.2e', mxEth, mxEph);
            app.perfLog('updatePeakSummaryLabels', toc(tLb));
            tAuto = tic;
            app.autoColorLimitsFromPattern();
            app.perfLog('autoColorLimitsFromPattern', toc(tAuto));
            app.refreshSinglePatternPlots();
            if ~skipPrincipalOrientation
                tPo = tic;
                app.applyPrincipalOrientationFromPattern();
                app.perfLog('applyPrincipalOrientationFromPattern', toc(tPo));
            end
            if app.perfEnabled
                app.perfLog('onProcessSingle_UI_tables_labels_plots_total', toc(tUiPipe));
            end
            tDwBatch = tic;
            try
                % expose/nocallbacks: flush graphics without running queued UI callbacks (spinner storms).
                drawnow expose nocallbacks;
            catch
                try
                    drawnow nocallbacks;
                catch
                    drawnow;
                end
            end
            if app.perfEnabled
                app.perfLog('onProcessSingle_flush_drawnow_expose_nocallbacks', toc(tDwBatch));
            end
        end

        function idx = ensureThetaPhiSortIdx(app)
            P = app.P_single;
            n = numel(P.theta(:));
            if isempty(app.thetaPhiSortIdx) || numel(app.thetaPhiSortIdx) ~= n
                if app.perfEnabled
                    ts = tic;
                end
                th = P.theta(:);
                ph = P.phi(:);
                [~, ord] = sortrows([th, ph]);
                app.thetaPhiSortIdx = ord(:);
                if app.perfEnabled
                    app.perfLog('ensureThetaPhiSortIdx_sortrows_recompute', toc(ts));
                end
            end
            idx = app.thetaPhiSortIdx;
        end

        function syncVisibleDataTables(app)
            if isempty(app.P_single) || isempty(app.R_single)
                return;
            end
            sel = [];
            try
                sel = app.TabsData.SelectedTab;
            catch
                return;
            end
            if isequal(sel, app.Tab_Input)
                app.populateInputTable('display');
            elseif isequal(sel, app.Tab_Output)
                app.populateOutputTable('display');
            end
        end

        function populateInputTable(app, mode)
            if isempty(app.P_single)
                return;
            end
            full = strcmp(mode, 'full');
            showAll = strcmp(mode, 'display_all');
            if ~full && ~showAll
                try
                    if ~isequal(app.TabsData.SelectedTab, app.Tab_Input)
                        return;
                    end
                catch
                    return;
                end
            end
            P = app.P_single;
            th = P.theta(:); ph = P.phi(:);
            gth = P.Gtheta_dB(:); gph = P.Gphi_dB(:);
            pt = P.phaseTheta_deg(:); pp = P.phasePhi_deg(:);
            idxFull = app.ensureThetaPhiSortIdx();
            nFull = numel(idxFull);
            idx = idxFull;
            if ~full && nFull > app.maxUITableDisplayRows
                idx = idxFull(1:app.maxUITableDisplayRows);
            end
            dat = [th(idx), ph(idx), gth(idx), gph(idx), pt(idx), pp(idx)];
            if app.perfEnabled
                td = tic;
            end
            app.Table_DataIn.Data = dat;
            if app.perfEnabled
                app.perfLog('populateInputTable_UI_assign', toc(td));
            end
            if full || nFull <= app.maxUITableDisplayRows
                app.Tab_Input.Title = 'Input';
            else
                app.Tab_Input.Title = sprintf('Input (showing %d of %d rows)', numel(idx), nFull);
            end
        end

        function populateOutputTable(app, mode)
            if isempty(app.R_single) || isempty(app.P_single)
                return;
            end
            full = strcmp(mode, 'full');
            showAll = strcmp(mode, 'display_all');
            if ~full && ~showAll
                try
                    if ~isequal(app.TabsData.SelectedTab, app.Tab_Output)
                        return;
                    end
                catch
                    return;
                end
            end
            R = app.R_single;
            P = app.P_single;
            n = numel(R.gainTotal_dB(:));
            th = P.theta(:); ph = P.phi(:);
            gtot = R.gainTotal_dB(:); gr = R.gainRHCP_dB(:); gl = R.gainLHCP_dB(:);
            pr = R.phaseRHCP_deg(:); pll = R.phaseLHCP_deg(:);
            gar = R.axialRatio_dB(:);
            gp = max(gr, gl);
            idxFull = app.ensureThetaPhiSortIdx();
            nFull = numel(idxFull);
            idx = idxFull;
            if ~full && nFull > app.maxUITableDisplayRows
                idx = idxFull(1:app.maxUITableDisplayRows);
            end
            dat = [th(idx), ph(idx), gtot(idx), gr(idx), gl(idx), pr(idx), pll(idx), ...
                   gar(idx), zeros(numel(idx), 1), gp(idx), nan(numel(idx), 3)];
            if app.perfEnabled
                td = tic;
            end
            app.Table_DataOut.Data = dat;
            if app.perfEnabled
                app.perfLog('populateOutputTable_UI_assign', toc(td));
            end
            if full || nFull <= app.maxUITableDisplayRows
                app.Tab_Output.Title = 'Output';
            else
                app.Tab_Output.Title = sprintf('Output (showing %d of %d rows)', numel(idx), nFull);
            end
        end

        function populateBothDataTablesDisplay(app)
            if isempty(app.P_single) || isempty(app.R_single)
                return;
            end
            app.populateInputTable('display_all');
            app.populateOutputTable('display_all');
        end

        function onExportInput(app)
            if isempty(app.P_single)
                uialert(app.UIFigure, 'Nothing to export.', 'Export');
                return
            end
            [f, p] = uiputfile('*.csv', 'Save input table', app.projRoot);
            if isnumeric(f), return; end
            app.populateInputTable('full');
            cn = cellstr(app.Table_DataIn.ColumnName(:));
            writetable(array2table(app.Table_DataIn.Data, 'VariableNames', matlab.lang.makeValidName(cn)), ...
                fullfile(p, f));
        end

        function onExportOutput(app)
            if isempty(app.R_single)
                uialert(app.UIFigure, 'Process first.', 'Export');
                return
            end
            [f, p] = uiputfile('*.csv', 'Save output table', app.projRoot);
            if isnumeric(f), return; end
            app.populateOutputTable('full');
            cn = cellstr(app.Table_DataOut.ColumnName(:));
            writetable(array2table(app.Table_DataOut.Data, 'VariableNames', matlab.lang.makeValidName(cn)), ...
                fullfile(p, f));
        end

        function onComponentChanged(app)
            app.refreshSinglePatternPlots();
        end

        function autoColorLimitsFromPattern(app)
            if isempty(app.R_single), return; end
            fld = app.currentComponentField(app.R_single);
            mx = max(fld(:));
            cmax = ceil(mx);
            cmin = cmax - 50;
            app.Input_Plot_Cmax.Value = cmax;
            app.Input_Plot_Cmin.Value = cmin;
        end

        function onPlotColorControlsChanged(app)
            if app.suppressPlotControlCallbacks
                return
            end
            % Color/spinner edits: clim + contour levels + polar cuts; skip heavy 3D/sphere/circular redraw.
            app.applyPatternColorLimits();
            if isempty(app.R_single), return; end
            fld = app.currentComponentField(app.R_single);
            app.updateContourAxes(fld);
            app.applyCutRectAxesLimits();
            app.refreshCutsSubplotsForSelection(fld);
        end

        function applyPatternColorLimits(app)
            if isempty(app.R_single), return; end
            cmin = app.Input_Plot_Cmin.Value;
            cmax = app.Input_Plot_Cmax.Value;
            if cmax <= cmin
                cmax = cmin + 1;
                app.Input_Plot_Cmax.Value = cmax;
            end
            clim(app.Axes_Contour, [cmin, cmax]);
            clim(app.Axes_Circular, [cmin, cmax]);
            clim(app.Axes_Spherical, [cmin, cmax]);
            clim(app.Axes_3D, [cmin, cmax]);
            clim(app.Axes_Filled, [cmin, cmax]);
        end

        function syncCutSpinnerLimits(app)
            % Phi cut  = φ varies at fixed θ  → fixed θ ∈ [0,180]
            % Theta cut = θ varies at fixed φ → fixed φ ∈ [0,360], mirrored φ+180 for full circle
            if strcmp(app.DropDown_CutType.Value, 'Phi Cut')
                app.Input_Cut_Value.Limits = [0 180];
                app.CutvalueLabel.Text = 'Cut value θ (deg):';
            else
                app.Input_Cut_Value.Limits = [0 360];
                app.CutvalueLabel.Text = 'Cut value φ (deg):';
            end
            v = app.Input_Cut_Value.Value;
            app.Input_Cut_Value.Value = min(max(v, app.Input_Cut_Value.Limits(1)), app.Input_Cut_Value.Limits(2));
        end

        function onCutControlChanged(app)
            app.syncCutSpinnerLimits();
            if isempty(app.R_single), return; end
            fld = app.currentComponentField(app.R_single);
            app.refreshCutsSubplotsForSelection(fld);
        end

        function fld = currentComponentField(app, R)
            switch app.DropDown_Component.Value
                case 'Total Gain'
                    fld = R.gainTotal_dB;
                case 'RHCP Gain'
                    fld = R.gainRHCP_dB;
                case 'LHCP  Gain'
                    fld = R.gainLHCP_dB;
                case 'Axial Ratio'
                    fld = R.axialRatio_dB;
                otherwise
                    fld = max(R.gainRHCP_dB, R.gainLHCP_dB);
            end
        end

        function restorePlotControlSuppress(app, prev)
            app.suppressPlotControlCallbacks = prev;
        end

        function refreshSinglePatternPlots(app)
            if isempty(app.R_single), return; end
            prevSuppress = app.suppressPlotControlCallbacks;
            deferPlotDrawnow = prevSuppress;
            app.suppressPlotControlCallbacks = true;
            cCleanup = onCleanup(@() app.restorePlotControlSuppress(prevSuppress)); %#ok<NASGU>
            fld = app.currentComponentField(app.R_single);
            if app.perfEnabled
                tRf = tic;
            end
            tSeg = tic;
            app.applyPatternColorLimits();
            if app.perfEnabled
                app.perfLog('refreshSinglePatternPlots.applyPatternColorLimits', toc(tSeg));
            end
            tSeg = tic;
            app.updateContourAxes(fld);
            if app.perfEnabled
                app.perfLog('refreshSinglePatternPlots.updateContourAxes', toc(tSeg));
            end
            tSeg = tic;
            app.refreshCutsSubplotsForSelection(fld);
            if app.perfEnabled
                app.perfLog('refreshSinglePatternPlots.refreshCutsSubplotsForSelection', toc(tSeg));
            end
            tSeg = tic;
            app.updateFullPatternPlots(fld);
            if app.perfEnabled
                app.perfLog('refreshSinglePatternPlots.updateFullPatternPlots', toc(tSeg));
            end
            if deferPlotDrawnow
                if app.perfEnabled
                    app.perfLog('refreshSinglePatternPlots.drawnow', 0);
                    app.perfLog('refreshSinglePatternPlots_TOTAL_cpu_until_flush_deferred', toc(tRf));
                end
            else
                tSeg = tic;
                try
                    drawnow expose nocallbacks;
                catch
                    try
                        drawnow nocallbacks;
                    catch
                        drawnow;
                    end
                end
                if app.perfEnabled
                    app.perfLog('refreshSinglePatternPlots.drawnow', toc(tSeg));
                    app.perfLog('refreshSinglePatternPlots_TOTAL', toc(tRf));
                end
            end
        end

        function onPatternSubtabChanged(app)
            if isempty(app.R_single), return; end
            fld = app.currentComponentField(app.R_single);
            app.updateFullPatternPlots(fld);
            app.applyPatternColorLimits();
        end

        function cm = cachedTurboJetColormap(app)
            if isempty(app.displayCmap256)
                try
                    app.displayCmap256 = turbo(256);
                catch
                    try
                        app.displayCmap256 = parula(256);
                    catch
                        app.displayCmap256 = jet(256);
                    end
                end
            end
            cm = app.displayCmap256;
        end

        function clearContourPlotCache(app)
            app.contourPlotCache = struct('key', '', 'PhiPlot', [], 'ThetaPlot', [], 'fldPlot', []);
            app.thetaPhiSortIdx = [];
        end

        function updateContourAxes(app, fldCached)
            if isempty(app.R_single), return; end
            if nargin < 2 || isempty(fldCached)
                fld = app.currentComponentField(app.R_single);
            else
                fld = fldCached;
            end
            Th = app.P_single.theta;
            Ph = app.P_single.phi;
            % Contour view only: subsample beyond ~42k cells so contourf + figure flush stay fast (cuts use full grid).
            if numel(fld) > 42000
                [fld, Th, Ph] = app.decimatePatternMesh(fld, Th, Ph, 91, 181);
            end
            phiLin = unique(Ph(1,:), 'sorted');
            thetaLin = unique(Th(:,1), 'sorted');
            % Duplicate φ=360 column (= φ=0 gain) so contour has no seam at periodic boundary
            if numel(phiLin) >= 4
                phSpan = max(phiLin) - min(phiLin);
                if phSpan >= 330 && phiLin(end) < 359.5 && abs(phiLin(1)) < 2.5
                    phiLin = [phiLin(:)', phiLin(1) + 360];
                    fld = [fld, fld(:, 1)];
                end
            end
            [PhiM, ThetaM] = meshgrid(phiLin, thetaLin);
            compStr = app.DropDown_Component.Value;
            if iscell(compStr) && ~isempty(compStr)
                compStr = char(compStr{1});
            elseif isa(compStr, 'string')
                compStr = char(compStr);
            end
            ck = sprintf('%s|%dx%d|%g|%g|%g|%g', compStr, ...
                size(fld, 1), size(fld, 2), phiLin(1), phiLin(end), thetaLin(1), thetaLin(end));
            C = app.contourPlotCache;
            reuse = ~isempty(C.key) && strcmp(C.key, ck) ...
                && ~isempty(C.PhiPlot) && isequal(size(C.PhiPlot), size(C.ThetaPlot)) ...
                && isequal(size(C.fldPlot), size(C.PhiPlot));
            if reuse
                PhiPlot = C.PhiPlot;
                ThetaPlot = C.ThetaPlot;
                fldPlot = C.fldPlot;
            else
                nPhiIn = numel(phiLin);
                nThIn = numel(thetaLin);
                nPts = nPhiIn * nThIn;
                denseEnough = nPts >= 48000 || (nPhiIn >= 240 && nThIn >= 120);
                if denseEnough
                    PhiPlot = PhiM;
                    ThetaPlot = ThetaM;
                    fldPlot = double(fld);
                else
                    maxFinePts = 280000;
                    mul = min(3, max(2, sqrt(maxFinePts / max(nPts, 1))));
                    nPhiT = min(481, max(nPhiIn, ceil(mul * nPhiIn)));
                    nThT = min(271, max(nThIn, ceil(mul * nThIn)));
                    phiFine = linspace(phiLin(1), phiLin(end), nPhiT);
                    thetaFine = linspace(thetaLin(1), thetaLin(end), nThT);
                    [PhiPlot, ThetaPlot] = meshgrid(phiFine, thetaFine);
                    fldPlot = interp2(PhiM, ThetaM, double(fld), PhiPlot, ThetaPlot, 'linear');
                end
                app.contourPlotCache.key = ck;
                app.contourPlotCache.PhiPlot = PhiPlot;
                app.contourPlotCache.ThetaPlot = ThetaPlot;
                app.contourPlotCache.fldPlot = fldPlot;
            end
            cla(app.Axes_Contour);
            cmin = app.Input_Plot_Cmin.Value;
            cmax = app.Input_Plot_Cmax.Value;
            step = max(app.Input_Plot_Cstep.Value, 1e-6);
            rng = max(cmax - cmin, eps);
            stepEff = min(step, max(rng / 64, eps));
            nLev = min(44, max(18, ceil(rng / stepEff)));
            lv = linspace(cmin, cmax, nLev);
            contourf(app.Axes_Contour, PhiPlot, ThetaPlot, fldPlot, lv, 'LineColor', 'none');
            app.Axes_Contour.XLabel.String = '\phi (deg)';
            app.Axes_Contour.YLabel.String = '\theta (deg)';
            app.Axes_Contour.Title.String = app.DropDown_Component.Value;
            app.Axes_Contour.XLim = [0 360];
            app.Axes_Contour.YLim = [0 180];
            app.Axes_Contour.XTick = 0:30:360;
            app.Axes_Contour.YTick = 0:15:180;
            app.Axes_Contour.YDir = 'reverse';
            colorbar(app.Axes_Contour);
            clim(app.Axes_Contour, [cmin, cmax]);
            cm = app.cachedTurboJetColormap();
            colormap(app.Axes_Contour, cm);
            app.Axes_Contour.Color = cm(1, :);
        end

        function [psi_deg, rho_g] = thetaCutMirroredSeries(~, fld, thCol, phRow, phi_cut_deg)
            [~, i0] = min(abs(phRow(:) - phi_cut_deg));
            ph_mirror = mod(phi_cut_deg + 180, 360);
            [~, i1] = min(abs(phRow(:) - ph_mirror));
            g0 = fld(:, i0);
            g1 = fld(:, i1);
            thv = thCol(:);
            g0 = g0(:);
            g1 = g1(:);
            [thS, ord] = sort(thv);
            g0s = g0(ord);
            g1s = g1(ord);
            n = numel(thS);
            psi_a = thS;
            psi_b = 360 - flip(thS(2:end));
            psi_deg = [psi_a; psi_b];
            rho_g = [g0s; flip(g1s(2:end))];
        end

        function updateCutPlot(app, fldCached)
            if isempty(app.R_single), return; end
            if nargin < 2 || isempty(fldCached)
                fld = app.currentComponentField(app.R_single);
            else
                fld = fldCached;
            end
            Th = app.P_single.theta;
            Ph = app.P_single.phi;
            phRow = Ph(1,:);
            thCol = Th(:,1);
            cut = app.Input_Cut_Value.Value;
            cla(app.Axes_Rect);
            if strcmp(app.DropDown_CutType.Value, 'Phi Cut')
                [~, kth] = min(abs(thCol(:) - cut));
                xplot = phRow(:);
                yplot = fld(kth, :).';
                [xplot, yplot] = app.closeRectPhiCut(xplot, yplot);
                xlab = '\phi (deg)';
                ttl = sprintf('Phi variation at fixed theta = %.2f deg', thCol(kth));
            else
                [psi_deg, rho_s] = app.thetaCutMirroredSeries(fld, thCol, phRow, cut);
                xplot = psi_deg;
                yplot = rho_s;
                [xplot, yplot] = app.closeRectThetaCut(xplot, yplot);
                xlab = 'Angle around full cut (deg)';
                ttl = sprintf('Theta variation: phi = %.1f deg (mirrored at %.1f deg)', mod(cut, 360), mod(cut + 180, 360));
            end
            plot(app.Axes_Rect, xplot, yplot, 'LineWidth', 1.2);
            app.Axes_Rect.XLabel.String = xlab;
            app.Axes_Rect.YLabel.String = [app.DropDown_Component.Value ' (dB)'];
            app.Axes_Rect.Title.String = ttl;
            grid(app.Axes_Rect, 'on');
            app.applyCutRectAxesLimits();
        end

        function [x, y] = closeRectPhiCut(~, phi_deg, y)
            phi_deg = phi_deg(:);
            y = y(:);
            ph = mod(phi_deg, 360);
            [ph_s, ord] = sort(ph);
            y_s = y(ord);
            keep = true(size(ph_s));
            for ii = 2:numel(ph_s)
                if abs(ph_s(ii) - ph_s(ii - 1)) < 1e-9
                    keep(ii - 1) = false;
                end
            end
            ph_s = ph_s(keep);
            y_s = y_s(keep);
            span = max(ph_s) - min(ph_s);
            wrapsBand = ph_s(1) <= 2 && ph_s(end) >= 358;
            if span >= 330 || wrapsBand
                x = [ph_s; ph_s(1) + 360];
                y = [y_s; y_s(1)];
            else
                x = ph_s;
                y = y_s;
            end
        end

        function [x, y] = closeRectThetaCut(~, psi_deg, y)
            psi_deg = psi_deg(:);
            y = y(:);
            pm = mod(psi_deg, 360);
            span = max(pm) - min(pm);
            if numel(psi_deg) >= 3 && span >= 330
                x = [psi_deg; psi_deg(1) + 360];
                y = [y; y(1)];
            else
                x = psi_deg;
                y = y;
            end
        end

        function applyCutRectAxesLimits(app)
            ax = app.Axes_Rect;
            cmin = app.Input_Plot_Cmin.Value;
            cmax = app.Input_Plot_Cmax.Value;
            if cmax <= cmin
                cmax = cmin + 1;
            end
            ax.XLim = [0 360];
            ax.XTick = 0:30:360;
            ax.YLim = [cmin, cmax];
        end

        function refreshCutsSubplotsForSelection(app, fldCached)
            if isempty(app.R_single), return; end
            if nargin < 2 || isempty(fldCached)
                fld = app.currentComponentField(app.R_single);
            else
                fld = fldCached;
            end
            selCut = [];
            try
                selCut = app.Tabs_Cuts.SelectedTab;
            catch
            end
            keys = {app.Tab_Rect, app.Tab_Polar, app.Tab_Filled};
            % Selected cut tab first, then the others (all subtabs stay warmed).
            order = 1:3;
            for ii = 1:3
                if ~isempty(selCut) && isequal(selCut, keys{ii})
                    order = [ii, order(order ~= ii)]; %#ok<AGROW>
                    break;
                end
            end
            drawCuts = {@() app.updateCutPlot(fld), @() app.updatePolarLineCut(fld), @() app.updateFilledPolarCut(fld)};
            for j = order
                drawCuts{j}();
            end
        end

        function onCutsTabsSelectionChanged(app)
            if isempty(app.R_single), return; end
            fld = app.currentComponentField(app.R_single);
            app.refreshCutsSubplotsForSelection(fld);
            try
                drawnow expose nocallbacks;
            catch
                try
                    drawnow nocallbacks;
                catch
                    drawnow;
                end
            end
        end

        function [phi_deg_c, rho_c] = polarCutPhiRho(app, fldCached)
            if isempty(app.R_single)
                phi_deg_c = zeros(0, 1);
                rho_c = zeros(0, 1);
                return
            end
            if nargin < 2 || isempty(fldCached)
                fld = app.currentComponentField(app.R_single);
            else
                fld = fldCached;
            end
            Th = app.P_single.theta;
            Ph = app.P_single.phi;
            phRow = Ph(1,:);
            thCol = Th(:,1);
            cut = app.Input_Cut_Value.Value;
            if strcmp(app.DropDown_CutType.Value, 'Phi Cut')
                [~, kth] = min(abs(thCol(:) - cut));
                rho = fld(kth, :)';
                [phi_deg_c, rho_c] = app.sortClosePhiCut(phRow(:), rho);
            else
                [psi_deg, rho] = app.thetaCutMirroredSeries(fld, thCol, phRow, cut);
                [phi_deg_c, rho_c] = app.closeThetaCutSeries(psi_deg(:), rho(:));
            end
        end

        function updatePolarLineCut(app, fldCached)
            if isempty(app.R_single), return; end
            [phi_deg_c, rho_c] = app.polarCutPhiRho(fldCached);
            if isempty(phi_deg_c), return; end
            cmin = app.Input_Plot_Cmin.Value;
            cmax = app.Input_Plot_Cmax.Value;
            cla(app.pax);
            app.applyPolarAxesConvention();
            phi_math_rad = deg2rad(phi_deg_c);
            theta_polar = phi_math_rad;
            rhoPlot = rho_c - cmin;
            rhoPlot = max(rhoPlot, eps);
            rhoPlot = min(rhoPlot, max(cmax - cmin, eps));
            polarplot(app.pax, theta_polar, rhoPlot, 'LineWidth', 1.5);
            app.applyPolarAxesConvention();
        end

        function updateFilledPolarCut(app, fldCached)
            if isempty(app.R_single), return; end
            [phi_deg_c, rho_c] = app.polarCutPhiRho(fldCached);
            if isempty(phi_deg_c), return; end
            cmin = app.Input_Plot_Cmin.Value;
            cmax = app.Input_Plot_Cmax.Value;
            phi_math_rad = deg2rad(phi_deg_c);
            rhoPlot = rho_c - cmin;
            rhoPlot = max(rhoPlot, eps);
            rhoPlot = min(rhoPlot, max(cmax - cmin, eps));
            angFilled = pi/2 - phi_math_rad;
            [xe, ye] = pol2cart(angFilled, rhoPlot);
            cv_hub = mean(rho_c(:));
            fv = [0 0; xe(:) ye(:)];
            rng = max(cmax - cmin, eps);
            t = (cv_hub - cmin) / rng;
            t = min(max(t, 0), 1);
            cm = app.cachedTurboJetColormap();
            ir = 1 + floor(t * (size(cm, 1) - 1));
            fc = cm(ir, :);
            cla(app.Axes_Filled);
            hold(app.Axes_Filled, 'on');
            patch('Parent', app.Axes_Filled, 'XData', fv(:,1), 'YData', fv(:,2), ...
                'FaceColor', fc, 'FaceAlpha', 0.88, ...
                'EdgeColor', [0.12 0.28 0.55], 'LineWidth', 1.2);
            plot(app.Axes_Filled, xe, ye, 'Color', [0.05 0.15 0.35], 'LineWidth', 1);
            axis(app.Axes_Filled, 'equal');
            grid(app.Axes_Filled, 'on');
            hold(app.Axes_Filled, 'off');
            app.Axes_Filled.Title.String = 'Filled polar cut';
        end

        function [phi_deg_c, rho_c] = sortClosePhiCut(~, phi_deg, rho)
            phi_deg = phi_deg(:);
            rho = rho(:);
            ph = mod(phi_deg, 360);
            [ph_s, ord] = sort(ph);
            rv = rho(ord);
            % Drop duplicate angles after wrap (keep last sample)
            keep = true(size(ph_s));
            for ii = 2:numel(ph_s)
                if abs(ph_s(ii) - ph_s(ii - 1)) < 1e-9
                    keep(ii - 1) = false;
                end
            end
            ph_s = ph_s(keep);
            rv = rv(keep);
            span = max(ph_s) - min(ph_s);
            wrapsBand = ph_s(1) <= 2 && ph_s(end) >= 358;
            if span >= 330 || wrapsBand
                phi_deg_c = [ph_s; ph_s(1) + 360];
                rho_c = [rv; rv(1)];
            else
                phi_deg_c = ph_s;
                rho_c = rv;
            end
        end

        function [phi_deg_c, rho_c] = closeThetaCutSeries(~, psi_deg, rho)
            % Preserve walking order from thetaCutMirroredSeries; only add seam if nearly full azimuth loop
            psi_deg = psi_deg(:);
            rho = rho(:);
            pm = mod(psi_deg, 360);
            span = max(pm) - min(pm);
            if numel(psi_deg) >= 3 && span >= 330
                phi_deg_c = [psi_deg; psi_deg(1) + 360];
                rho_c = [rho; rho(1)];
            else
                phi_deg_c = psi_deg;
                rho_c = rho;
            end
        end

        function [az, el] = peekCurrent3DView(app)
        % Read actual camera orientation from 3D axes (survives rotate3d), sync spinners.
            az = app.DViewAzSpinner.Value;
            el = app.DviewElSpinner.Value;
            try
                axCam = app.lastCameraAxesHandle;
                if ~isgraphics(axCam)
                    axCam = app.Axes_3D;
                end
                [azc, elc] = view(axCam);
                if isfinite(azc) && isfinite(elc)
                    az = azc;
                    el = elc;
                end
            catch
            end
            app.suppressViewSpinner = true;
            try
                app.DViewAzSpinner.Value = az;
                app.DviewElSpinner.Value = el;
            catch
            end
            app.suppressViewSpinner = false;
        end

        function [fldO, ThO, PhO] = decimatePatternMesh(~, fld, Th, Ph, maxR, maxC)
            [nr, nc] = size(fld);
            maxR = max(8, maxR);
            maxC = max(8, maxC);
            if nr <= maxR && nc <= maxC
                fldO = fld;
                ThO = Th;
                PhO = Ph;
                return
            end
            ri = round(linspace(1, nr, min(nr, maxR)));
            ci = round(linspace(1, nc, min(nc, maxC)));
            fldO = fld(ri, ci);
            ThO = Th(ri, ci);
            PhO = Ph(ri, ci);
        end

        function resetRadOverlayCache(app, ax)
            if isequal(ax, app.Axes_Spherical)
                app.lastRadOverlayKeySpherical = NaN;
            elseif isequal(ax, app.Axes_3D)
                app.lastRadOverlayKey3D = NaN;
            end
        end

        function hs = upsertPatternSurface(app, ax, tag, X, Y, Z, Cdata)
            hsAll = findobj(ax, 'Type', 'surface', 'Tag', tag);
            if isempty(hsAll)
                app.resetRadOverlayCache(ax);
                cla(ax);
                hs = surf(ax, X, Y, Z, Cdata, 'EdgeColor', 'none', 'Tag', tag);
                return
            end
            hs = hsAll(1);
            if ~isequal(size(X), size(get(hs, 'XData')))
                delete(hsAll);
                app.resetRadOverlayCache(ax);
                cla(ax);
                hs = surf(ax, X, Y, Z, Cdata, 'EdgeColor', 'none', 'Tag', tag);
                return
            end
            set(hs, 'XData', X, 'YData', Y, 'ZData', Z, 'CData', Cdata);
        end

        function updateFullPatternPlots(app, fldCached)
            % Redraws Circular / Spherical / 3D pattern subtabs (selected tab first, then the others).
            if isempty(app.R_single), return; end
            if nargin < 2 || isempty(fldCached)
                fld = app.currentComponentField(app.R_single);
            else
                fld = fldCached;
            end
            Th = app.P_single.theta;
            Ph = app.P_single.phi;
            [fldD, ThD, PhD] = app.decimatePatternMesh(fld, Th, Ph, 101, 181);
            cmin = app.Input_Plot_Cmin.Value;
            cmax = app.Input_Plot_Cmax.Value;
            cm = app.cachedTurboJetColormap();

            selTab = [];
            try
                selTab = app.Tabs_Pattern.SelectedTab;
            catch
            end
            drawOrder = app.patternHeavySubtabDrawOrder(selTab);

            [azKeep, elKeep] = app.peekCurrent3DView();

            th = deg2rad(ThD);
            ph = deg2rad(PhD);
            X = sin(th) .* cos(ph);
            Y = sin(th) .* sin(ph);
            Z = cos(th);

            fn3 = fldD - min(fldD(:));
            fn3 = fn3 ./ (max(fn3(:)) + eps);
            amp = 0.2 + 0.8 .* fn3;
            Xs = X .* amp;
            Ys = Y .* amp;
            Zs = Z .* amp;
            rOv = max(sqrt(Xs(:).^2 + Ys(:).^2 + Zs(:).^2));

            for pass = 1:3
                k = drawOrder(pass);
                switch k
                    case 1
                        phRad = deg2rad(PhD);
                        rnorm = ThD / 180;
                        Xcirc = rnorm .* sin(phRad);
                        Ycirc = rnorm .* cos(phRad);

                        cla(app.Axes_Circular);
                        surf(app.Axes_Circular, Xcirc, Ycirc, zeros(size(Xcirc)), fldD, 'EdgeColor', 'none');
                        view(app.Axes_Circular, 2);
                        axis(app.Axes_Circular, 'equal');
                        hold(app.Axes_Circular, 'on');
                        tt = linspace(0, 2*pi, 97);
                        for rk = 30:30:180
                            rn = rk / 180;
                            plot(app.Axes_Circular, rn * sin(tt), rn * cos(tt), ':', 'Color', [0.78 0.78 0.78]);
                        end
                        for phg = 0:30:330
                            phr = deg2rad(phg);
                            plot(app.Axes_Circular, [0 sin(phr)], [0 cos(phr)], ':', 'Color', [0.78 0.78 0.78]);
                        end
                        rm = 1.07;
                        for phg = 0:30:330
                            phr = deg2rad(phg);
                            text(app.Axes_Circular, rm * sin(phr), rm * cos(phr), sprintf('%d°', phg), ...
                                'HorizontalAlignment', 'center', 'FontSize', 8, ...
                                'Tag', 'apa_circ_lbl', 'Interpreter', 'tex');
                        end
                        for rk = 30:30:150
                            rn = rk / 180;
                            text(app.Axes_Circular, -rn * 1.02, 0, sprintf('\\theta=%d°', rk), ...
                                'HorizontalAlignment', 'center', 'FontSize', 8, ...
                                'Tag', 'apa_circ_lbl', 'Interpreter', 'tex');
                        end
                        hold(app.Axes_Circular, 'off');
                        shading(app.Axes_Circular, 'interp');
                        colormap(app.Axes_Circular, cm);
                        colorbar(app.Axes_Circular);
                        clim(app.Axes_Circular, [cmin, cmax]);
                        title(app.Axes_Circular, 'Circular/polar map (\phi around rim, \theta radial)');
                        axis(app.Axes_Circular, 'off');

                    case 2
                        app.upsertPatternSurface(app.Axes_Spherical, 'apa_surf', X, Y, Z, fldD);
                        axis(app.Axes_Spherical, 'equal');
                        view(app.Axes_Spherical, azKeep, elKeep);
                        shading(app.Axes_Spherical, 'interp');
                        colormap(app.Axes_Spherical, cm);
                        colorbar(app.Axes_Spherical);
                        title(app.Axes_Spherical, 'Spherical (unit sphere, color = pattern)');
                        app.overlayRadiation3DHelpers(app.Axes_Spherical, 1.0);

                    case 3
                        app.upsertPatternSurface(app.Axes_3D, 'apa_surf', Xs, Ys, Zs, fldD);
                        axis(app.Axes_3D, 'equal');
                        view(app.Axes_3D, azKeep, elKeep);
                        shading(app.Axes_3D, 'interp');
                        colormap(app.Axes_3D, cm);
                        colorbar(app.Axes_3D);
                        title(app.Axes_3D, '3D pattern (radius scaled by gain)');
                        app.overlayRadiation3DHelpers(app.Axes_3D, max(rOv, eps));
                end
            end
        end

        function ord = patternHeavySubtabDrawOrder(app, selTab)
            ord = [1 2 3];
            if nargin < 2 || isempty(selTab)
                return;
            end
            if isequal(selTab, app.Tab3_Spherical)
                ord = [2 1 3];
            elseif isequal(selTab, app.Tab4_3D)
                ord = [3 1 2];
            end
        end

        function overlayRadiation3DHelpers(app, ax, RSurf)
            key = round(double(RSurf) * 1e6) / 1e6;
            if isequal(ax, app.Axes_Spherical)
                if isfinite(app.lastRadOverlayKeySpherical) && abs(app.lastRadOverlayKeySpherical - key) < 1e-9
                    return
                end
                app.lastRadOverlayKeySpherical = key;
            elseif isequal(ax, app.Axes_3D)
                if isfinite(app.lastRadOverlayKey3D) && abs(app.lastRadOverlayKey3D - key) < 1e-9
                    return
                end
                app.lastRadOverlayKey3D = key;
            end
            delete(findall(ax, 'Tag', 'apa_rad3d'));
            hold(ax, 'on');
            Rax = RSurf * 1.08;
            Rcirc = max(RSurf * 1.22, RSurf + 0.12);
            plot3(ax, [0 Rax], [0 0], [0 0], 'Color', [0.85 0.2 0.15], 'LineWidth', 1.4, 'Tag', 'apa_rad3d');
            plot3(ax, [0 0], [0 Rax], [0 0], 'Color', [0.2 0.65 0.25], 'LineWidth', 1.4, 'Tag', 'apa_rad3d');
            plot3(ax, [0 0], [0 0], [0 Rax], 'Color', [0.15 0.35 0.85], 'LineWidth', 1.4, 'Tag', 'apa_rad3d');
            text(ax, Rax * 1.08, 0, 0, 'X', 'Color', [0.85 0.2 0.15], 'FontWeight', 'bold', ...
                'FontSize', 11, 'HorizontalAlignment', 'left', 'Tag', 'apa_rad3d');
            text(ax, 0, Rax * 1.08, 0, 'Y', 'Color', [0.2 0.65 0.25], 'FontWeight', 'bold', ...
                'FontSize', 11, 'HorizontalAlignment', 'left', 'Tag', 'apa_rad3d');
            text(ax, 0, 0, Rax * 1.08, 'Z', 'Color', [0.15 0.35 0.85], 'FontWeight', 'bold', ...
                'FontSize', 11, 'HorizontalAlignment', 'left', 'Tag', 'apa_rad3d');
            tt = linspace(0, 2*pi, 73);
            xe = Rcirc * cos(tt); ye = Rcirc * sin(tt); ze = zeros(size(tt));
            plot3(ax, xe, ye, ze, 'Color', [0.35 0.35 0.35], 'LineStyle', '--', 'LineWidth', 0.9, 'Tag', 'apa_rad3d');
            % Full principal circles (xz and yz planes), not semicircles
            ta = linspace(0, 2*pi, 73);
            xz_x = Rcirc * cos(ta);
            xz_z = Rcirc * sin(ta);
            plot3(ax, xz_x, zeros(size(ta)), xz_z, 'Color', [0.35 0.35 0.35], 'LineStyle', ':', 'LineWidth', 0.9, 'Tag', 'apa_rad3d');
            yz_y = Rcirc * cos(ta);
            yz_z = Rcirc * sin(ta);
            plot3(ax, zeros(size(ta)), yz_y, yz_z, 'Color', [0.35 0.35 0.35], 'LineStyle', ':', 'LineWidth', 0.9, 'Tag', 'apa_rad3d');
            hold(ax, 'off');
        end

        function attach3DCameraListeners(app)
            try
                addlistener(app.Axes_3D, 'CameraPosition', 'PostSet', @(~,~) app.onAxesCameraPostSet(app.Axes_3D));
                addlistener(app.Axes_Spherical, 'CameraPosition', 'PostSet', @(~,~) app.onAxesCameraPostSet(app.Axes_Spherical));
                addlistener(app.Axes_3D, 'CameraTarget', 'PostSet', @(~,~) app.onAxesCameraPostSet(app.Axes_3D));
                addlistener(app.Axes_Spherical, 'CameraTarget', 'PostSet', @(~,~) app.onAxesCameraPostSet(app.Axes_Spherical));
                addlistener(app.Axes_3D, 'CameraViewAngle', 'PostSet', @(~,~) app.onAxesCameraPostSet(app.Axes_3D));
                addlistener(app.Axes_Spherical, 'CameraViewAngle', 'PostSet', @(~,~) app.onAxesCameraPostSet(app.Axes_Spherical));
                addlistener(app.Axes_3D, 'CameraUpVector', 'PostSet', @(~,~) app.onAxesCameraPostSet(app.Axes_3D));
                addlistener(app.Axes_Spherical, 'CameraUpVector', 'PostSet', @(~,~) app.onAxesCameraPostSet(app.Axes_Spherical));
            catch
            end
        end

        function syncViewSpinnersFromAxes(app)
            if app.suppressViewSpinner || app.camBusy
                return
            end
            try
                axCam = app.lastCameraAxesHandle;
                if ~isgraphics(axCam)
                    axCam = app.Axes_3D;
                end
                [az, el] = view(axCam);
                if ~(isfinite(az) && isfinite(el))
                    [az, el] = view(app.Axes_Spherical);
                end
                if ~(isfinite(az) && isfinite(el)), return; end
                app.suppressViewSpinner = true;
                app.DViewAzSpinner.Value = az;
                app.DviewElSpinner.Value = el;
                app.suppressViewSpinner = false;
                view(app.Axes_Spherical, az, el);
                view(app.Axes_3D, az, el);
                app.DViewpresetDropDown.Value = '3D View preset,';
                app.DropDown_output.Value = '3D View preset,';
            catch
            end
        end

        function onWindowButtonUp(app, ~, ~)
            if isempty(app.R_single) && isempty(app.P_combine_list)
                return
            end
            axHit = app.axesUnderPointer();
            if ~isempty(axHit)
                app.lastCameraAxesHandle = axHit;
            end
            app.syncViewSpinnersFromAxes();
        end

        function onAxesCameraPostSet(app, srcAx)
            if app.camBusy || app.suppressViewSpinner
                return
            end
            if isgraphics(srcAx)
                app.lastCameraAxesHandle = srcAx;
            end
            app.camBusy = true;
            c = onCleanup(@() app.releaseCamBusy());
            try
                [az, el] = view(srcAx);
                if isequal(srcAx, app.Axes_3D)
                    tgt = app.Axes_Spherical;
                else
                    tgt = app.Axes_3D;
                end
                view(tgt, az, el);
                app.suppressViewSpinner = true;
                app.DViewAzSpinner.Value = az;
                app.DviewElSpinner.Value = el;
                app.suppressViewSpinner = false;
                app.DViewpresetDropDown.Value = '3D View preset,';
                app.DropDown_output.Value = '3D View preset,';
            catch
            end
        end

        function releaseCamBusy(app)
            app.camBusy = false;
        end

        function on3DViewSpinnersChanged(app)
            if app.suppressViewSpinner
                return
            end
            app.camBusy = true;
            c = onCleanup(@() app.releaseCamBusy());
            az = app.DViewAzSpinner.Value;
            el = app.DviewElSpinner.Value;
            app.lastCameraAxesHandle = app.Axes_3D;
            view(app.Axes_3D, az, el);
            view(app.Axes_Spherical, az, el);
            app.DViewpresetDropDown.Value = '3D View preset,';
            app.DropDown_output.Value = '3D View preset,';
        end

        function on3DPresetDropdownChanged(app)
            [az, el, ok] = app.parsePresetAzEl(app.DViewpresetDropDown.Value);
            if ~ok, return; end
            app.suppressViewSpinner = true;
            app.DViewAzSpinner.Value = az;
            app.DviewElSpinner.Value = el;
            app.suppressViewSpinner = false;
            app.camBusy = true;
            c = onCleanup(@() app.releaseCamBusy());
            view(app.Axes_3D, az, el);
            view(app.Axes_Spherical, az, el);
            app.lastCameraAxesHandle = app.Axes_3D;
        end

        function onDropDownOutputViewChanged(app)
            [az, el, ok] = app.parsePresetAzEl(app.DropDown_output.Value);
            if ~ok, return; end
            app.suppressViewSpinner = true;
            app.DViewAzSpinner.Value = az;
            app.DviewElSpinner.Value = el;
            app.suppressViewSpinner = false;
            app.DViewpresetDropDown.Value = app.DropDown_output.Value;
            app.camBusy = true;
            c = onCleanup(@() app.releaseCamBusy());
            view(app.Axes_3D, az, el);
            view(app.Axes_Spherical, az, el);
            app.lastCameraAxesHandle = app.Axes_3D;
        end

        function [az, el, ok] = parsePresetAzEl(app, presetStr)
            ok = true;
            switch strtrim(presetStr)
                case {'3D View preset,'}
                    az = app.DViewAzSpinner.Value;
                    el = app.DviewElSpinner.Value;
                    ok = false;
                case {'Top View (+Z),'}
                    az = 0; el = 90;
                case {'Bottom View (+Z),'}
                    az = 180; el = -90;
                case {'Right View (+Y),'}
                    az = 90; el = 0;
                case {'Left View (-Y),'}
                    az = -90; el = 0;
                case {'Front View (+X),'}
                    az = 0; el = 0;
                case {'Back View (-X),'}
                    az = 180; el = 0;
                otherwise
                    az = app.DViewAzSpinner.Value;
                    el = app.DviewElSpinner.Value;
                    ok = false;
            end
        end

        function onLoadBatch(app)
            d = uigetdir(app.projRoot, 'Folder containing pattern files (.fz, .uan, …, recursive)');
            if d == 0, return; end
            app.Input_PatternField_Batch.Value = d;
            app.fzList = findPatternFiles(d);
            app.Input_Label_2.Text = sprintf('Found %d pattern file(s).', numel(app.fzList));
        end

        function onProcessBatch(app)
            if isempty(app.fzList)
                uialert(app.UIFigure, 'Load a folder first.', 'Batch');
                return
            end
            rows = cell(0, 4);
            for i = 1:numel(app.fzList)
                fz = app.fzList{i};
                try
                    P = io.loadPattern(fz);
                    R = proc.processPattern(P, struct);
                    rows(end+1, :) = {fz, R.maxGain_dB, P.meta.header.maximum_gain, ''}; %#ok<AGROW>
                catch ME
                    rows(end+1, :) = {fz, nan, nan, ME.message}; %#ok<AGROW>
                end
            end
            app.batchResults = cell2table(rows, 'VariableNames', ...
                {'File', 'MaxGain_dB', 'HeaderMax_dB', 'Error'});
            app.Input_Label_2.Text = sprintf('Processed %d file(s).', height(app.batchResults));
        end

        function onExportBatchSummary(app)
            if isempty(app.batchResults) || height(app.batchResults)==0
                uialert(app.UIFigure, 'Run batch process first.', 'Export');
                return
            end
            [f, p] = uiputfile('*.csv', 'Save batch summary', app.projRoot);
            if isnumeric(f), return; end
            writetable(app.batchResults, fullfile(p, f));
        end

        function onLoadCoverage(app)
            prev = pwd;
            c = onCleanup(@() cd(prev));
            try
                cd(app.projRoot);
            catch
            end
            [fn, fp] = uigetfile( ...
                {'*.fz;*.uan;*.ffs;*.ffd;*.ffe;*.out', 'Antenna patterns'; '*.*', 'All Files'}, ...
                'Select pattern for coverage');
            if isnumeric(fn), return; end
            fz = fullfile(fp, fn);
            app.Input_PatternField_Coverage.Value = fz;
            try
                app.P_cov = io.loadPattern(fz);
                app.R_cov = proc.processPattern(app.P_cov, struct);
            catch ME
                uialert(app.UIFigure, ME.message, 'Load error');
            end
        end

        function onCoverageModeChanged(app)
            con = app.Button_Conical.Value;
            if con
                en = 'on';
            else
                en = 'off';
            end
            app.Spinner_coneTH.Enable = en;
            app.Spinner_conePH.Enable = en;
            app.Spinner_coneAng.Enable = en;
            app.Cone0Label.Enable = en;
            app.ConeLabel.Enable = en;
            app.CongAngleLabel.Enable = en;
        end

        function onProcessCoverage(app)
            if isempty(app.R_cov)
                uialert(app.UIFigure, 'Load a pattern first.', 'Coverage');
                return
            end
            opts = struct('thrMin', app.Spinner_threshMin.Value, 'thrMax', app.Spinner_threshMax.Value, 'thrStep', app.Spinner_threshStep.Value);
            if app.Button_Conical.Value
                opts.coneTheta_deg = app.Spinner_coneTH.Value;
                opts.conePhi_deg = app.Spinner_conePH.Value;
                opts.coneAlpha_deg = app.Spinner_coneAng.Value;
                mode = 'conical';
            else
                mode = 'spherical';
            end
            [thr, cov] = proc.computeCoverage(app.R_cov, mode, opts);
            plot(app.UIAxes, thr, cov, 'LineWidth', 1.5);
            app.UIAxes.XLabel.String = 'Threshold (dB)';
            app.UIAxes.YLabel.String = 'Coverage (%)';
            app.UIAxes.Title.String = [mode ' coverage'];
            grid(app.UIAxes, 'on');
            app.UITable.Data = [thr, cov];
            app.UITable.ColumnName = {'Threshold_dB', 'Coverage_pct'};

            fp = app.Input_PatternField_Coverage.Value;
            if isempty(fp)
                fp = 'pattern';
            end
            [~, base, ext] = fileparts(fp);
            label = sprintf('%s%s · run %d', base, ext, numel(app.coverageList) + 1);
            ent = struct('label', label, 'path', fp, 'P', app.P_cov, 'R', app.R_cov);
            app.coverageList{end+1} = ent;
            app.refreshCoverageTree();
        end

        function onClearCoverage(app)
            cla(app.UIAxes);
            app.UITable.Data = [];
            app.coverageList = {};
            app.refreshCoverageTree();
        end

        function onExportCoverage(app)
            if isempty(app.UITable.Data)
                uialert(app.UIFigure, 'Run coverage first.', 'Export');
                return
            end
            [f, p] = uiputfile('*.csv', 'Save coverage curve', app.projRoot);
            if isnumeric(f), return; end
            cn = cellstr(app.UITable.ColumnName(:));
            writetable(array2table(app.UITable.Data, 'VariableNames', matlab.lang.makeValidName(cn)), ...
                fullfile(p, f));
        end

        function onLoadCombine(app)
            prev = pwd;
            c = onCleanup(@() cd(prev));
            try
                cd(app.projRoot);
            catch
            end
            [fn, fp] = uigetfile( ...
                {'*.fz;*.uan;*.ffs;*.ffd;*.ffe;*.out', 'Antenna patterns'; '*.*', 'All Files'}, ...
                'Select one or more patterns', ...
                'MultiSelect', 'on');
            if isnumeric(fn), return; end
            if ischar(fn), fn = {fn}; end
            newPaths = cellfun(@(f) fullfile(fp, f), fn, 'UniformOutput', false);
            app.combineFiles = unique([app.combineFiles(:); newPaths(:)], 'stable');
            app.P_combine_list = cell(size(app.combineFiles));
            app.R_combine_list = cell(size(app.combineFiles));
            tBatch = tic;
            for ii = 1:numel(app.combineFiles)
                try
                    tOne = tic;
                    app.P_combine_list{ii} = io.loadPattern(app.combineFiles{ii});
                    app.perfLog(sprintf('loadCombine[%d]/loadPattern', ii), toc(tOne));
                    tProc = tic;
                    app.R_combine_list{ii} = proc.processPattern(app.P_combine_list{ii}, struct);
                    app.perfLog(sprintf('loadCombine[%d]/processPattern', ii), toc(tProc));
                catch ME
                    uialert(app.UIFigure, ME.message, 'Load combine pattern');
                    app.P_combine_list{ii} = [];
                    app.R_combine_list{ii} = [];
                end
            end
            app.perfLog('loadCombine batch total', toc(tBatch));
            app.lastCombinePreviewSig = '';
            app.refreshCombineTree(struct('selectAll', true));
            app.onCombineMethodChanged();
            app.refreshCombinePreviewPlots();
        end

        function onClearCombine(app)
            app.lastCombinePreviewSig = '';
            app.combineFiles = {};
            app.P_combine_list = {};
            app.R_combine_list = {};
            app.lastCombinedQ = [];
            app.combineLabelSeq = 0;
            app.combinePhiEdges = [];
            app.combineThetaEdges = [];
            app.refreshCombineTree();
            app.refreshCombinePreviewPlots();
            app.onCombineMethodChanged();
        end

        function onCombinePatterns(app)
            if numel(app.combineFiles) < 1
                uialert(app.UIFigure, 'Select one or more pattern files first.', 'Combine');
                return
            end
            idx = app.getCombineCheckedIndices();
            if isempty(idx)
                uialert(app.UIFigure, ...
                    'Select at least one pattern in the tree (checkboxes). Unchecked patterns are excluded.', ...
                    'Combine');
                return
            end
            Ps = cell(1, numel(idx));
            for j = 1:numel(idx)
                i = idx(j);
                if i <= numel(app.P_combine_list) && ~isempty(app.P_combine_list{i})
                    Ps{j} = app.P_combine_list{i};
                else
                    Ps{j} = io.loadPattern(app.combineFiles{i});
                end
            end
            tComb = tic;
            if app.RadioButton_Method1.Value
                w = ones(numel(Ps), 1) / numel(Ps);
                Q = proc.combinePatterns(Ps, 'coherent', struct('weights', w));
            elseif app.RadioButton_Method2.Value
                uialert(app.UIFigure, 'Best-source selection is not implemented yet; using coherent sum.', 'Combine');
                w = ones(numel(Ps), 1) / numel(Ps);
                Q = proc.combinePatterns(Ps, 'coherent', struct('weights', w));
            else
                if numel(Ps) < 2
                    uialert(app.UIFigure, 'Regional masking needs at least two checked patterns.', 'Combine');
                    return
                end
                [tb, pb] = app.readCombineMaskBands(numel(Ps));
                if proc.regionalMaskAnyOverlap(tb, pb)
                    uialert(app.UIFigure, ...
                        'Two or more θ–φ sectors overlap. Adjust the mask table before combining.', ...
                        'Regional mask');
                    return
                end
                Q = proc.combinePatterns(Ps, 'masked', struct('thetaBands', tb, 'phiBands', pb, 'useAllRows', true));
            end
            app.perfLog('combinePatterns', toc(tComb));
            app.lastCombinedQ = Q;
            app.combineLabelSeq = app.combineLabelSeq + 1;
            nc = numel(app.combineFiles) + 1;
            app.combineFiles{nc} = sprintf('Combined #%d', app.combineLabelSeq);
            app.P_combine_list{nc} = Q;
            app.P_single = Q;
            app.clearContourPlotCache();
            tPost = tic;
            app.R_single = proc.processPattern(Q, struct);
            app.R_combine_list{nc} = app.R_single;
            app.perfLog('processPattern(combined)', toc(tPost));
            app.TabGroup.SelectedTab = app.Tab1_Single;
            prevSupCb = app.suppressPlotControlCallbacks;
            app.suppressPlotControlCallbacks = true;
            cCombFlush = onCleanup(@() app.restorePlotControlSuppress(prevSupCb)); %#ok<NASGU>
            app.populateBothDataTablesDisplay();
            app.refreshSinglePatternPlots();
            app.refreshCombineTree(struct('ensureCheckedIndices', nc));
            app.refreshCombinePreviewPlots();
            tDwComb = tic;
            try
                drawnow expose nocallbacks;
            catch
                try
                    drawnow nocallbacks;
                catch
                    drawnow;
                end
            end
            if app.perfEnabled
                app.perfLog('onCombinePatterns_flush_drawnow_expose_nocallbacks', toc(tDwComb));
            end
        end

        function onExportCombined(app)
            if isempty(app.lastCombinedQ)
                uialert(app.UIFigure, 'Combine patterns first.', 'Export');
                return
            end
            [f, p] = uiputfile('*.mat', 'Save combined pattern struct', app.projRoot);
            if isnumeric(f), return; end
            Q = app.lastCombinedQ;
            save(fullfile(p, f), 'Q', '-v7.3');
        end

        function refreshCombinePreviewPlots(app)
            if ~isgraphics(app.Combine_Viz_Panel)
                return
            end
            idxSel = app.getCombineCheckedIndices();
            nf = numel(idxSel);
            tb = []; pb = [];
            wantMask = app.RadioButton_Method3.Value && nf >= 2;
            if wantMask
                try
                    [tb, pb] = app.readCombineMaskBands(nf);
                catch
                    tb = []; pb = [];
                    wantMask = false;
                end
            end
            azV = app.DViewAzSpinner.Value;
            elV = app.DviewElSpinner.Value;
            try
                axCam = app.lastCameraAxesHandle;
                if isgraphics(axCam)
                    [azV, elV] = view(axCam);
                end
            catch
            end
            sig = sprintf('nfiles%d|nf%d|%s|%d|%d_%d', numel(app.combineFiles), nf, sprintf('%d_', idxSel), wantMask, ...
                round(double(azV) * 40), round(double(elV) * 40));
            if wantMask && ~isempty(tb)
                sig = [sig '|' sprintf('%.5g_', tb(:)') sprintf('%.5g_', pb(:)')]; %#ok<AGROW>
            end
            if strcmp(sig, app.lastCombinePreviewSig)
                ch = app.Combine_Viz_Panel.Children;
                if ~isempty(ch) && all(isgraphics(ch))
                    return
                end
            end
            app.lastCombinePreviewSig = sig;
            delete(app.Combine_Viz_Panel.Children);
            if numel(app.P_combine_list) < 1
                return
            end
            tl = tiledlayout(app.Combine_Viz_Panel, 'flow', 'Padding', 'compact', 'TileSpacing', 'compact');
            for j = 1:nf
                i = idxSel(j);
                Pi = app.P_combine_list{i};
                Ri = app.R_combine_list{i};
                if isempty(Pi) || isempty(Ri)
                    continue
                end
                ax = nexttile(tl);
                [~, bn] = fileparts(app.combineFiles{i});
                if wantMask && ~isempty(tb) && size(tb, 1) >= j
                    app.plotMiniPatternGain(ax, Pi, Ri, bn, tb(j, :), pb(j, :), azV, elV);
                else
                    app.plotMiniPatternGain(ax, Pi, Ri, bn, [], [], azV, elV);
                end
            end
        end

        function plotMiniPatternGain(app, ax, P, R, ttl, thetaBand, phiBand, azView, elView)
            if nargin < 8 || isempty(elView)
                elView = app.DviewElSpinner.Value;
            end
            if nargin < 7 || isempty(azView)
                azView = app.DViewAzSpinner.Value;
            end
            if nargin < 6
                phiBand = [];
            end
            if nargin < 5
                thetaBand = [];
            end
            cla(ax);
            Th = P.theta;
            Ph = P.phi;
            fld = R.gainTotal_dB;
            [fld, Th, Ph] = app.decimatePatternMesh(fld, Th, Ph, 48, 96);
            th = deg2rad(Th);
            ph = deg2rad(Ph);
            X = sin(th) .* cos(ph);
            Y = sin(th) .* sin(ph);
            Z = cos(th);
            surf(ax, X, Y, Z, fld, 'EdgeColor', 'none');
            axis(ax, 'equal');
            shading(ax, 'interp');
            colormap(ax, app.cachedTurboJetColormap());
            title(ax, ttl, 'Interpreter', 'none');
            if numel(thetaBand) >= 2 && numel(phiBand) >= 2
                app.overlayCombineMaskBounds(ax, thetaBand(:)', phiBand(:)');
            end
            view(ax, azView, elView);
        end

        function overlayCombineMaskBounds(~, ax, thBand, phBand)
            delete(findall(ax, 'Tag', 'apa_mask_ov'));
            th1 = thBand(1); th2 = thBand(2);
            ph1 = phBand(1); ph2 = phBand(2);
            Rov = 1.018;
            phiSpan = mod(ph2 - ph1 + 360, 360);
            phiFull360 = phiSpan >= 359.25 || phiSpan <= 0.75;
            hold(ax, 'on');
            if phiFull360
                phFine = linspace(0, 360, 129);
            elseif ph2 >= ph1
                phFine = linspace(ph1, ph2, max(32, min(180, round(abs(ph2 - ph1)) + 1)));
            else
                phFine = linspace(ph1, ph2 + 360, max(32, min(360, round(ph2 + 360 - ph1) + 1)));
                phFine = mod(phFine, 360);
            end
            Nth = max(16, min(90, round(abs(th2 - th1)) + 1));
            thFine = linspace(th1, th2, Nth);
            for thc = [th1, th2]
                if phiFull360 && thc <= 0.15
                    continue
                end
                tc = deg2rad(thc * ones(size(phFine)));
                pc = deg2rad(phFine(:)');
                X = Rov * sin(tc) .* cos(pc);
                Y = Rov * sin(tc) .* sin(pc);
                Z = Rov * cos(tc);
                plot3(ax, X(:), Y(:), Z(:), 'Color', [1 0.92 0.12], 'LineWidth', 1.35, 'Tag', 'apa_mask_ov');
            end
            if ~phiFull360
                phLo = mod(ph1, 360); phHi = mod(ph2, 360);
                merid = unique([phLo; phHi]);
                for k = 1:numel(merid)
                    phc = merid(k);
                    tc = deg2rad(thFine);
                    pc = deg2rad(phc * ones(size(tc)));
                    X = Rov * sin(tc) .* cos(pc);
                    Y = Rov * sin(tc) .* sin(pc);
                    Z = Rov * cos(tc);
                    plot3(ax, X(:), Y(:), Z(:), 'Color', [1 0.92 0.12], 'LineWidth', 1.35, 'Tag', 'apa_mask_ov');
                end
            end
            hold(ax, 'off');
        end

        function onWindowMotionSyncView(app, ~, ~)
            if app.suppressViewSpinner || app.camBusy
                return
            end
            if isempty(app.R_single) && isempty(app.P_combine_list)
                return
            end
            if isempty(app.lastViewSyncT) || ~isa(app.lastViewSyncT, 'uint64')
                app.lastViewSyncT = tic;
                return
            end
            if toc(app.lastViewSyncT) < 0.1
                return
            end
            app.lastViewSyncT = tic;
            app.syncSpinnersOnlyFromAxes();
            app.syncPartner3DViewFromLeader();
        end

        function syncSpinnersOnlyFromAxes(app)
            if app.suppressViewSpinner || app.camBusy
                return
            end
            try
                axHit = app.axesUnderPointer();
                if ~isempty(axHit) && (isequal(axHit, app.Axes_3D) || isequal(axHit, app.Axes_Spherical))
                    app.lastCameraAxesHandle = axHit;
                end
                axCam = app.lastCameraAxesHandle;
                if ~isgraphics(axCam)
                    axCam = app.Axes_3D;
                end
                [az, el] = view(axCam);
                if ~(isfinite(az) && isfinite(el))
                    [az, el] = view(app.Axes_Spherical);
                end
                if ~(isfinite(az) && isfinite(el))
                    return
                end
                app.suppressViewSpinner = true;
                app.DViewAzSpinner.Value = az;
                app.DviewElSpinner.Value = el;
                app.suppressViewSpinner = false;
            catch
            end
        end

        function axHit = axesUnderPointer(app)
            axHit = [];
            try
                fig = app.UIFigure;
                if ~isgraphics(fig)
                    return
                end
                h = hittest(fig);
                if isempty(h) || ~isgraphics(h)
                    return
                end
                ax = ancestor(h, 'axes');
                if isempty(ax) || ~isgraphics(ax)
                    return
                end
                if isequal(ax, app.Axes_3D) || isequal(ax, app.Axes_Spherical)
                    axHit = ax;
                end
            catch
                axHit = [];
            end
        end

        function populateRotationAngleDropdowns(app)
            ths = (0:5:180)';
            phs = (0:15:345)';
            app.fillDegDropdown(app.SourceDropDown, ths);
            app.fillDegDropdown(app.SourceDropDown_2, phs);
            app.fillDegDropdown(app.TargetDropDown, ths);
            app.fillDegDropdown(app.TargetDropDown_2, phs);
        end

        function fillDegDropdown(~, dd, vals)
            vals = vals(:);
            lbls = cell(numel(vals), 1);
            for k = 1:numel(vals)
                lbls{k} = sprintf('%.0f°', vals(k));
            end
            dd.Items = lbls;
            dd.ItemsData = vals;
            % With numeric ItemsData, Value must be an element of ItemsData (not the label text).
            dd.Value = vals(1);
        end

        function d = dropdownDeg(app, dd)
            d = app.rotationDropdownDeg(dd);
        end

        function d = rotationDropdownDeg(app, dd)
            % Reads numeric angle (deg) from uidropdown with numeric ItemsData or editable text.
            try
                v = dd.Value;
                if isnumeric(v) && isscalar(v) && isfinite(v)
                    d = double(v);
                    return
                end
                if isprop(dd, 'ItemsData') && ~isempty(dd.ItemsData) && (ischar(v) || isstring(v))
                    idx = find(strcmp(string(dd.Items), string(v)), 1);
                    if ~isempty(idx) && numel(dd.ItemsData) >= idx && isnumeric(dd.ItemsData(idx))
                        d = double(dd.ItemsData(idx));
                        return
                    end
                end
                d = app.scalarDeg(v);
            catch
                d = app.scalarDeg(dd.Value);
            end
        end

        function perfLog(app, label, dtSec)
            if ~app.perfEnabled
                return
            end
            line = sprintf('[APA perf] %s: %.4f s', label, dtSec);
            try
                fprintf('%s\n', line);
            catch
            end
            try
                app.recordPerfToWorkspace(label, dtSec);
            catch
            end
        end

        function perfLogTotal(app, label, dtSec, varargin)
            if ~app.perfEnabled
                return
            end
            updateWorkspacePrimary = true;
            k = 1;
            while k <= numel(varargin) - 1
                if strcmpi(varargin{k}, 'WorkspacePrimary')
                    updateWorkspacePrimary = logical(varargin{k + 1});
                end
                k = k + 2;
            end
            line = sprintf('[APA perf TOTAL] %s: %.4f s', label, dtSec);
            try
                fprintf('%s\n', line);
            catch
            end
            try
                app.recordPerfToWorkspace(['TOTAL__' char(string(label))], dtSec);
            catch
            end
            if updateWorkspacePrimary
                try
                    assignin('base', 'APA_perfLastTotalSeconds', double(dtSec));
                    assignin('base', 'APA_perfLastTotalLabel', char(string(label)));
                catch
                end
            end
        end

        function recordPerfToWorkspace(~, label, dtSec)
            stepName = char(string(label));
            ts = datetime('now');
            newRow = table({stepName}, double(dtSec), ts, ...
                'VariableNames', {'Step', 'Seconds', 'Timestamp'});
            try
                if evalin('base', 'exist(''APA_perfHistory'',''var'')')
                    old = evalin('base', 'APA_perfHistory');
                    if istable(old) && width(old) == width(newRow)
                        APA_perfHistory = [old; newRow];
                    else
                        APA_perfHistory = newRow;
                    end
                else
                    APA_perfHistory = newRow;
                end
                maxHist = 2500;
                if height(APA_perfHistory) > maxHist
                    APA_perfHistory = APA_perfHistory(end - maxHist + 1:end, :);
                end
                assignin('base', 'APA_perfHistory', APA_perfHistory);
            catch
            end
            try
                assignin('base', 'APA_perfLast', struct( ...
                    'Step', stepName, ...
                    'Seconds', double(dtSec), ...
                    'Timestamp', ts));
            catch
            end
        end

        function onRotatePattern(app)
            if isempty(app.P_single)
                uialert(app.UIFigure, 'Load a pattern first.', 'Rotate');
                return
            end
            try
                ths = app.rotationDropdownDeg(app.SourceDropDown);
                phs = app.rotationDropdownDeg(app.SourceDropDown_2);
                tht = app.rotationDropdownDeg(app.TargetDropDown);
                pht = app.rotationDropdownDeg(app.TargetDropDown_2);
            catch ME
                uialert(app.UIFigure, ME.message, 'Rotate');
                return
            end
            t0 = tic;
            try
                app.P_single = proc.rotatePattern(app.P_single, 'directions', ths, phs, tht, pht);
                app.clearContourPlotCache();
                app.perfLog('rotatePattern(directions)', toc(t0));
            catch ME
                uialert(app.UIFigure, ME.message, 'Rotate');
                return
            end
            app.suppressOrientationPreset = true;
            try
                app.snapRotationDropdownToNearest(app.SourceDropDown, tht, false);
                app.snapRotationDropdownToNearest(app.SourceDropDown_2, mod(pht, 360), true);
                app.DropDown_Orientation.Value = app.orientationDropdownFromAngles(tht, mod(pht, 360));
            catch
            end
            app.suppressOrientationPreset = false;
            try
                app.onProcessSingle(true);
            catch ME
                uialert(app.UIFigure, ME.message, 'Process');
            end
        end

        function snapRotationDropdownToNearest(~, dd, degVal, wrapPhi)
            if nargin < 4
                wrapPhi = false;
            end
            if ~isprop(dd, 'ItemsData') || isempty(dd.ItemsData)
                return
            end
            data = double(dd.ItemsData(:));
            dv = double(degVal);
            if wrapPhi
                dist = abs(mod(dv - data + 180, 360) - 180);
            else
                dist = abs(data - dv);
            end
            [~, ix] = min(dist);
            dd.Value = data(ix);
        end

        function applyPrincipalOrientationFromPattern(app)
            if isempty(app.P_single) || isempty(app.R_single)
                return
            end
            try
                lbl = proc.estimatePrincipalOrientation(app.P_single, app.R_single);
                [th0, ph0] = app.orientationPresetAngles(lbl);
                app.suppressOrientationPreset = true;
                try
                    app.DropDown_Orientation.Value = lbl;
                    app.snapRotationDropdownToNearest(app.SourceDropDown, th0, false);
                    app.snapRotationDropdownToNearest(app.SourceDropDown_2, ph0, true);
                catch
                end
                app.suppressOrientationPreset = false;
            catch
                app.suppressOrientationPreset = false;
            end
        end

        function onOrientationPresetChanged(app)
            if app.suppressOrientationPreset
                return
            end
            sel = app.DropDown_Orientation.Value;
            if strcmp(sel, 'Orientation:') || strcmp(sel, 'Custom')
                return
            end
            [th0, ph0] = app.orientationPresetAngles(sel);
            app.suppressOrientationPreset = true;
            try
                app.SourceDropDown.Value = th0;
                app.SourceDropDown_2.Value = ph0;
            catch ME
                app.suppressOrientationPreset = false;
                uialert(app.UIFigure, ME.message, 'Orientation preset');
                return
            end
            app.suppressOrientationPreset = false;
        end

        function onSourceAngleControlsChanged(app)
            if app.suppressOrientationPreset
                return
            end
            try
                th = app.rotationDropdownDeg(app.SourceDropDown);
                ph = app.rotationDropdownDeg(app.SourceDropDown_2);
            catch
                return
            end
            sel = app.orientationDropdownFromAngles(th, ph);
            if strcmp(sel, app.DropDown_Orientation.Value)
                return
            end
            app.suppressOrientationPreset = true;
            try
                app.DropDown_Orientation.Value = sel;
            catch
            end
            app.suppressOrientationPreset = false;
        end

        function [th, ph] = orientationPresetAngles(~, sel)
            switch sel
                case 'Source: +X (Fwd)'
                    th = 90; ph = 0;
                case 'Source: -X (Aft)'
                    th = 90; ph = 180;
                case 'Source: +Y (Stbd)'
                    th = 90; ph = 90;
                case 'Source: -Y (Port)'
                    th = 90; ph = 270;
                case 'Source: +Z (Zenith)'
                    th = 0; ph = 0;
                case 'Source: -Z (Deck)'
                    th = 180; ph = 0;
                otherwise
                    th = 90; ph = 0;
            end
        end

        function sel = orientationDropdownFromAngles(app, th, ph)
            tol = 0.75;
            if th < tol
                sel = 'Source: +Z (Zenith)';
                return
            end
            if abs(th - 180) < tol
                sel = 'Source: -Z (Deck)';
                return
            end
            presets = { ...
                'Source: +X (Fwd)', 90, 0; ...
                'Source: -X (Aft)', 90, 180; ...
                'Source: +Y (Stbd)', 90, 90; ...
                'Source: -Y (Port)', 90, 270};
            for k = 1:size(presets, 1)
                thp = presets{k, 2};
                php = presets{k, 3};
                if abs(th - thp) < tol && app.angleDegClose(ph, php, tol)
                    sel = presets{k, 1};
                    return
                end
            end
            sel = 'Custom';
        end

        function tf = angleDegClose(~, ph, ph0, tol)
            d = abs(mod(ph - ph0 + 180, 360) - 180);
            tf = d < tol;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            colormap(app.UIFigure, 'jet');
            app.UIFigure.Position = [100 100 1161 787];
            app.UIFigure.Name = 'Antenna Pattern Analyzer';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'1x'};

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = 1;
            app.TabGroup.Layout.Column = 1;

            % Create Tab1_Single
            app.Tab1_Single = uitab(app.TabGroup);
            app.Tab1_Single.Title = 'Single Pattern';

            % Create Tab1_Grid
            app.Tab1_Grid = uigridlayout(app.Tab1_Single);
            app.Tab1_Grid.ColumnWidth = {'1x', '1x', '0.3x'};
            app.Tab1_Grid.RowHeight = {'fit', '1.5x', 'fit', '1x'};

            % Create Tab1_Panel1
            app.Tab1_Panel1 = uipanel(app.Tab1_Grid);
            app.Tab1_Panel1.Title = 'Inputs & Parameters';
            app.Tab1_Panel1.Layout.Row = 1;
            app.Tab1_Panel1.Layout.Column = [1 3];

            % Create T1P1_Grid
            app.T1P1_Grid = uigridlayout(app.Tab1_Panel1);
            app.T1P1_Grid.ColumnWidth = {'1x', '1x', 'fit', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.T1P1_Grid.RowHeight = {'1x', '1x', '1x', '1x'};

            % Create FormatLabel
            app.FormatLabel = uilabel(app.T1P1_Grid);
            app.FormatLabel.HorizontalAlignment = 'right';
            app.FormatLabel.Layout.Row = 1;
            app.FormatLabel.Layout.Column = 1;
            app.FormatLabel.Text = 'Format:';

            % Create DropDown_Format
            app.DropDown_Format = uidropdown(app.T1P1_Grid);
            app.DropDown_Format.Items = {'Eθ, Eϕ [mag_dB,phase°]', 'Eθ, Eϕ [Re,Im]', 'Erh, Elh [mag,phase°]', 'Erh, Elh [Re,Im]', 'Gain Pattern'};
            app.DropDown_Format.ItemsData = {'1', '2', '3', '4', '5'};
            app.DropDown_Format.Layout.Row = 1;
            app.DropDown_Format.Layout.Column = 2;
            app.DropDown_Format.Value = '1';

            % Create InputPatternLabel
            app.InputPatternLabel = uilabel(app.T1P1_Grid);
            app.InputPatternLabel.HorizontalAlignment = 'right';
            app.InputPatternLabel.Layout.Row = 1;
            app.InputPatternLabel.Layout.Column = 3;
            app.InputPatternLabel.Text = 'Input Pattern:';

            % Create Input_PatternField
            app.Input_PatternField = uieditfield(app.T1P1_Grid, 'text');
            app.Input_PatternField.Editable = 'off';
            app.Input_PatternField.Placeholder = '(No file loaded)';
            app.Input_PatternField.Layout.Row = 1;
            app.Input_PatternField.Layout.Column = [4 10];

            % Create Button_Load_Single
            app.Button_Load_Single = uibutton(app.T1P1_Grid, 'push');
            app.Button_Load_Single.Layout.Row = 1;
            app.Button_Load_Single.Layout.Column = 11;
            app.Button_Load_Single.Text = 'Load';

            % Create Button_Process_Single
            app.Button_Process_Single = uibutton(app.T1P1_Grid, 'push');
            app.Button_Process_Single.Layout.Row = 1;
            app.Button_Process_Single.Layout.Column = 12;
            app.Button_Process_Single.Text = 'Process';

            % Create Input_Label
            app.Input_Label = uilabel(app.T1P1_Grid);
            app.Input_Label.Layout.Row = 2;
            app.Input_Label.Layout.Column = [1 5];
            app.Input_Label.Text = 'Input file details';

            % Create Button_ExportInput
            app.Button_ExportInput = uibutton(app.T1P1_Grid, 'push');
            app.Button_ExportInput.Layout.Row = 2;
            app.Button_ExportInput.Layout.Column = 11;
            app.Button_ExportInput.Text = 'Export Input';

            % Create Button_ExportOutput
            app.Button_ExportOutput = uibutton(app.T1P1_Grid, 'push');
            app.Button_ExportOutput.Layout.Row = 2;
            app.Button_ExportOutput.Layout.Column = 12;
            app.Button_ExportOutput.Text = 'Export Output';

            % Create LossidBLabel
            app.LossidBLabel = uilabel(app.T1P1_Grid);
            app.LossidBLabel.HorizontalAlignment = 'right';
            app.LossidBLabel.Layout.Row = 3;
            app.LossidBLabel.Layout.Column = 1;
            app.LossidBLabel.Text = 'Loss (dB):';

            % Create Input_Loss
            app.Input_Loss = uispinner(app.T1P1_Grid);
            app.Input_Loss.Layout.Row = 3;
            app.Input_Loss.Layout.Column = 2;

            % Create IncidentWaveARRw_dBLabel
            app.IncidentWaveARRw_dBLabel = uilabel(app.T1P1_Grid);
            app.IncidentWaveARRw_dBLabel.HorizontalAlignment = 'right';
            app.IncidentWaveARRw_dBLabel.Layout.Row = 3;
            app.IncidentWaveARRw_dBLabel.Layout.Column = 3;
            app.IncidentWaveARRw_dBLabel.Text = 'Rw (Incident Wave AR dB):';

            % Create Input_Rw
            app.Input_Rw = uispinner(app.T1P1_Grid);
            app.Input_Rw.Layout.Row = 3;
            app.Input_Rw.Layout.Column = 4;
            app.Input_Rw.Value = 6;

            % Create TxPowerdBLabel
            app.TxPowerdBLabel = uilabel(app.T1P1_Grid);
            app.TxPowerdBLabel.HorizontalAlignment = 'right';
            app.TxPowerdBLabel.Layout.Row = 3;
            app.TxPowerdBLabel.Layout.Column = 5;
            app.TxPowerdBLabel.Text = 'Pt (Tx Power):';

            % Create Input_Pt
            app.Input_Pt = uispinner(app.T1P1_Grid);
            app.Input_Pt.Layout.Row = 3;
            app.Input_Pt.Layout.Column = 6;

            % Create DropDown_Pt
            app.DropDown_Pt = uidropdown(app.T1P1_Grid);
            app.DropDown_Pt.Items = {'dBW', 'dBm', 'Watts'};
            app.DropDown_Pt.Layout.Row = 3;
            app.DropDown_Pt.Layout.Column = 7;
            app.DropDown_Pt.Value = 'dBW';

            % Create DistanceLabel
            app.DistanceLabel = uilabel(app.T1P1_Grid);
            app.DistanceLabel.HorizontalAlignment = 'right';
            app.DistanceLabel.Layout.Row = 3;
            app.DistanceLabel.Layout.Column = 8;
            app.DistanceLabel.Text = 'R (E-field Range, m):';

            % Create Input_Distance
            app.Input_Distance = uispinner(app.T1P1_Grid);
            app.Input_Distance.Limits = [0.1 Inf];
            app.Input_Distance.Layout.Row = 3;
            app.Input_Distance.Layout.Column = 9;
            app.Input_Distance.Value = 1;

            % Create DropDown_Step
            app.DropDown_Step = uidropdown(app.T1P1_Grid);
            app.DropDown_Step.Items = {'Select STEP', 'STEP: 1°'};
            app.DropDown_Step.Layout.Row = 3;
            app.DropDown_Step.Layout.Column = 11;
            app.DropDown_Step.Value = 'Select STEP';

            % Create DominantPolLabel
            app.DominantPolLabel = uilabel(app.T1P1_Grid);
            app.DominantPolLabel.Layout.Row = 2;
            app.DominantPolLabel.Layout.Column = 6;
            app.DominantPolLabel.Text = 'Dominant Pol';

            % Create Label_MaxGain
            app.Label_MaxGain = uilabel(app.T1P1_Grid);
            app.Label_MaxGain.Layout.Row = 2;
            app.Label_MaxGain.Layout.Column = [7 8];
            app.Label_MaxGain.Interpreter = 'tex';
            app.Label_MaxGain.Text = 'Max Gain sprintf(''\Theta/\Phi'')';

            % Create Label_MaxInputE
            app.Label_MaxInputE = uilabel(app.T1P1_Grid);
            app.Label_MaxInputE.Layout.Row = 2;
            app.Label_MaxInputE.Layout.Column = [9 10];
            app.Label_MaxInputE.Text = 'Max Input Eθ/Eφ component';

            % Create ComputeCoverageButton
            app.ComputeCoverageButton = uibutton(app.T1P1_Grid, 'push');
            app.ComputeCoverageButton.Layout.Row = 3;
            app.ComputeCoverageButton.Layout.Column = 12;
            app.ComputeCoverageButton.Text = 'Compute Coverage';

            % Create DropDown_Orientation
            app.DropDown_Orientation = uidropdown(app.T1P1_Grid);
            app.DropDown_Orientation.Items = {'Orientation:', 'Source: +X (Fwd)', 'Source: -X (Aft)', 'Source: +Y (Stbd)', 'Source: -Y (Port)', 'Source: +Z (Zenith)', 'Source: -Z (Deck)', 'Custom'};
            app.DropDown_Orientation.Layout.Row = 4;
            app.DropDown_Orientation.Layout.Column = 2;
            app.DropDown_Orientation.Value = 'Orientation:';

            th = (0:5:180)';
            ph = (0:15:345)';
            thList = arrayfun(@(x) sprintf('%g°', x), th, 'UniformOutput', false);
            phList = arrayfun(@(x) sprintf('%g°', x), ph, 'UniformOutput', false);

            % Create SourceLabel
            app.SourceLabel = uilabel(app.T1P1_Grid);
            app.SourceLabel.HorizontalAlignment = 'right';
            app.SourceLabel.Layout.Row = 4;
            app.SourceLabel.Layout.Column = 3;
            app.SourceLabel.Text = 'Source θ:';

            % Create SourceDropDown
            app.SourceDropDown = uidropdown(app.T1P1_Grid);
            app.SourceDropDown.Layout.Row = 4;
            app.SourceDropDown.Layout.Column = 4;
            app.SourceDropDown.Items = thList;
            app.SourceDropDown.ItemsData = th;
            app.SourceDropDown.Value = th(1);

            % Create SourceDropDown_2Label
            app.SourceDropDown_2Label = uilabel(app.T1P1_Grid);
            app.SourceDropDown_2Label.HorizontalAlignment = 'right';
            app.SourceDropDown_2Label.Layout.Row = 4;
            app.SourceDropDown_2Label.Layout.Column = 5;
            app.SourceDropDown_2Label.Text = 'Source φ';

            % Create SourceDropDown_2
            app.SourceDropDown_2 = uidropdown(app.T1P1_Grid);
            app.SourceDropDown_2.Layout.Row = 4;
            app.SourceDropDown_2.Layout.Column = 6;
            app.SourceDropDown_2.Items = phList;
            app.SourceDropDown_2.ItemsData = ph;
            app.SourceDropDown_2.Value = ph(1);

            % Create TargetDropDownLabel
            app.TargetDropDownLabel = uilabel(app.T1P1_Grid);
            app.TargetDropDownLabel.HorizontalAlignment = 'right';
            app.TargetDropDownLabel.Layout.Row = 4;
            app.TargetDropDownLabel.Layout.Column = 7;
            app.TargetDropDownLabel.Text = 'Target θ:';

            % Create TargetDropDown
            app.TargetDropDown = uidropdown(app.T1P1_Grid);
            app.TargetDropDown.Layout.Row = 4;
            app.TargetDropDown.Layout.Column = 8;
            app.TargetDropDown.Items = thList;
            app.TargetDropDown.ItemsData = th;
            app.TargetDropDown.Value = th(1);

            % Create TargetDropDown_2Label
            app.TargetDropDown_2Label = uilabel(app.T1P1_Grid);
            app.TargetDropDown_2Label.HorizontalAlignment = 'right';
            app.TargetDropDown_2Label.Layout.Row = 4;
            app.TargetDropDown_2Label.Layout.Column = 9;
            app.TargetDropDown_2Label.Text = 'Target φ:';

            % Create TargetDropDown_2
            app.TargetDropDown_2 = uidropdown(app.T1P1_Grid);
            app.TargetDropDown_2.Layout.Row = 4;
            app.TargetDropDown_2.Layout.Column = 10;
            app.TargetDropDown_2.Items = phList;
            app.TargetDropDown_2.ItemsData = ph;
            app.TargetDropDown_2.Value = ph(1);

            try
                app.SourceDropDown.Editable = 'on';
                app.SourceDropDown_2.Editable = 'on';
            catch
            end

            % Create Button_Rotation
            app.Button_Rotation = uibutton(app.T1P1_Grid, 'push');
            app.Button_Rotation.Layout.Row = 4;
            app.Button_Rotation.Layout.Column = [11 12];
            app.Button_Rotation.Text = 'Rotate (Target Boresight)';

            % Create RotationLabel
            app.RotationLabel = uilabel(app.T1P1_Grid);
            app.RotationLabel.Layout.Row = 4;
            app.RotationLabel.Layout.Column = 1;
            app.RotationLabel.Text = 'Rotation:';

            % Create Panel_PlotControls
            app.Panel_PlotControls = uipanel(app.Tab1_Grid);
            app.Panel_PlotControls.Title = 'Plot Controls';
            app.Panel_PlotControls.Layout.Row = 2;
            app.Panel_PlotControls.Layout.Column = 3;

            % Create Grid_PlotCtrl
            app.Grid_PlotCtrl = uigridlayout(app.Panel_PlotControls);
            app.Grid_PlotCtrl.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit'};

            % Create ComponentLabel
            app.ComponentLabel = uilabel(app.Grid_PlotCtrl);
            app.ComponentLabel.HorizontalAlignment = 'right';
            app.ComponentLabel.Layout.Row = 1;
            app.ComponentLabel.Layout.Column = 1;
            app.ComponentLabel.Text = 'Component:';

            % Create DropDown_Component
            app.DropDown_Component = uidropdown(app.Grid_PlotCtrl);
            app.DropDown_Component.Items = {'Total Gain', 'RHCP Gain', 'LHCP  Gain', 'Axial Ratio', 'Polarized Gain'};
            app.DropDown_Component.Layout.Row = 1;
            app.DropDown_Component.Layout.Column = 2;
            app.DropDown_Component.Value = 'Total Gain';

            % Create CuttypeDropDownLabel
            app.CuttypeDropDownLabel = uilabel(app.Grid_PlotCtrl);
            app.CuttypeDropDownLabel.HorizontalAlignment = 'right';
            app.CuttypeDropDownLabel.Layout.Row = 2;
            app.CuttypeDropDownLabel.Layout.Column = 1;
            app.CuttypeDropDownLabel.Text = 'Cut type:';

            % Create DropDown_CutType
            app.DropDown_CutType = uidropdown(app.Grid_PlotCtrl);
            app.DropDown_CutType.Items = {'Phi Cut', 'Theta Cut'};
            app.DropDown_CutType.Layout.Row = 2;
            app.DropDown_CutType.Layout.Column = 2;
            app.DropDown_CutType.Value = 'Phi Cut';

            % Create CutvalueLabel
            app.CutvalueLabel = uilabel(app.Grid_PlotCtrl);
            app.CutvalueLabel.HorizontalAlignment = 'right';
            app.CutvalueLabel.Layout.Row = 3;
            app.CutvalueLabel.Layout.Column = 1;
            app.CutvalueLabel.Text = 'Cut value:';

            % Create Input_Cut_Value
            app.Input_Cut_Value = uispinner(app.Grid_PlotCtrl);
            app.Input_Cut_Value.Limits = [0 360];
            app.Input_Cut_Value.Layout.Row = 3;
            app.Input_Cut_Value.Layout.Column = 2;

            % Create ColorbarminLabel
            app.ColorbarminLabel = uilabel(app.Grid_PlotCtrl);
            app.ColorbarminLabel.HorizontalAlignment = 'right';
            app.ColorbarminLabel.Layout.Row = 4;
            app.ColorbarminLabel.Layout.Column = 1;
            app.ColorbarminLabel.Text = 'Colorbar min:';

            % Create Input_Plot_Cmin
            app.Input_Plot_Cmin = uispinner(app.Grid_PlotCtrl);
            app.Input_Plot_Cmin.Layout.Row = 4;
            app.Input_Plot_Cmin.Layout.Column = 2;
            app.Input_Plot_Cmin.Value = -40;

            % Create ColorbarmaxLabel
            app.ColorbarmaxLabel = uilabel(app.Grid_PlotCtrl);
            app.ColorbarmaxLabel.HorizontalAlignment = 'right';
            app.ColorbarmaxLabel.Layout.Row = 5;
            app.ColorbarmaxLabel.Layout.Column = 1;
            app.ColorbarmaxLabel.Text = 'Colorbar max:';

            % Create Input_Plot_Cmax
            app.Input_Plot_Cmax = uispinner(app.Grid_PlotCtrl);
            app.Input_Plot_Cmax.Layout.Row = 5;
            app.Input_Plot_Cmax.Layout.Column = 2;
            app.Input_Plot_Cmax.Value = 10;

            % Create ColorbarstepLabel
            app.ColorbarstepLabel = uilabel(app.Grid_PlotCtrl);
            app.ColorbarstepLabel.HorizontalAlignment = 'right';
            app.ColorbarstepLabel.Layout.Row = 6;
            app.ColorbarstepLabel.Layout.Column = 1;
            app.ColorbarstepLabel.Text = 'Colorbar step:';

            % Create Input_Plot_Cstep
            app.Input_Plot_Cstep = uispinner(app.Grid_PlotCtrl);
            app.Input_Plot_Cstep.Layout.Row = 6;
            app.Input_Plot_Cstep.Layout.Column = 2;
            app.Input_Plot_Cstep.Value = 10;

            % Create DViewAzSpinnerLabel
            app.DViewAzSpinnerLabel = uilabel(app.Grid_PlotCtrl);
            app.DViewAzSpinnerLabel.HorizontalAlignment = 'right';
            app.DViewAzSpinnerLabel.Layout.Row = 7;
            app.DViewAzSpinnerLabel.Layout.Column = 1;
            app.DViewAzSpinnerLabel.Text = '3D View Az:';

            % Create DViewAzSpinner
            app.DViewAzSpinner = uispinner(app.Grid_PlotCtrl);
            app.DViewAzSpinner.Limits = [-360 360];
            app.DViewAzSpinner.Layout.Row = 7;
            app.DViewAzSpinner.Layout.Column = 2;
            app.DViewAzSpinner.Value = -37.5;

            % Create DviewElSpinnerLabel
            app.DviewElSpinnerLabel = uilabel(app.Grid_PlotCtrl);
            app.DviewElSpinnerLabel.HorizontalAlignment = 'right';
            app.DviewElSpinnerLabel.Layout.Row = 8;
            app.DviewElSpinnerLabel.Layout.Column = 1;
            app.DviewElSpinnerLabel.Text = '3D view El:';

            % Create DviewElSpinner
            app.DviewElSpinner = uispinner(app.Grid_PlotCtrl);
            app.DviewElSpinner.Limits = [-90 90];
            app.DviewElSpinner.Layout.Row = 8;
            app.DviewElSpinner.Layout.Column = 2;
            app.DviewElSpinner.Value = 30;

            % Create DViewpresetDropDownLabel
            app.DViewpresetDropDownLabel = uilabel(app.Grid_PlotCtrl);
            app.DViewpresetDropDownLabel.HorizontalAlignment = 'right';
            app.DViewpresetDropDownLabel.Layout.Row = 9;
            app.DViewpresetDropDownLabel.Layout.Column = 1;
            app.DViewpresetDropDownLabel.Text = '3D View preset';

            % Create DViewpresetDropDown
            app.DViewpresetDropDown = uidropdown(app.Grid_PlotCtrl);
            app.DViewpresetDropDown.Items = {'3D View preset,', 'Top View (+Z),', 'Bottom View (+Z),', 'Right View (+Y),', 'Left View (-Y),', 'Front View (+X),', 'Back View (-X)'};
            app.DViewpresetDropDown.Layout.Row = 9;
            app.DViewpresetDropDown.Layout.Column = 2;
            app.DViewpresetDropDown.Value = '3D View preset,';

            % Create Panel_Pattern
            app.Panel_Pattern = uipanel(app.Tab1_Grid);
            app.Panel_Pattern.Title = 'Full Antenna Pattern';
            app.Panel_Pattern.Layout.Row = [2 3];
            app.Panel_Pattern.Layout.Column = 1;

            % Create Grid_Pattern
            app.Grid_Pattern = uigridlayout(app.Panel_Pattern);
            app.Grid_Pattern.ColumnWidth = {'1x'};
            app.Grid_Pattern.RowHeight = {'1x'};

            % Create Tabs_Pattern
            app.Tabs_Pattern = uitabgroup(app.Grid_Pattern);
            app.Tabs_Pattern.Layout.Row = 1;
            app.Tabs_Pattern.Layout.Column = 1;

            % Create Tab1_Contour
            app.Tab1_Contour = uitab(app.Tabs_Pattern);
            app.Tab1_Contour.Title = 'Controur';

            % Create Grid_Contour
            app.Grid_Contour = uigridlayout(app.Tab1_Contour);
            app.Grid_Contour.ColumnWidth = {'1x'};
            app.Grid_Contour.RowHeight = {'1x'};

            % Create Axes_Contour
            app.Axes_Contour = uiaxes(app.Grid_Contour);
            title(app.Axes_Contour, 'Title')
            xlabel(app.Axes_Contour, 'X')
            ylabel(app.Axes_Contour, 'Y')
            zlabel(app.Axes_Contour, 'Z')
            app.Axes_Contour.Layout.Row = 1;
            app.Axes_Contour.Layout.Column = 1;
            colormap(app.Axes_Contour, 'jet')

            % Create Tab2_Circular
            app.Tab2_Circular = uitab(app.Tabs_Pattern);
            app.Tab2_Circular.Title = 'Circular';

            % Create Grid_Circular
            app.Grid_Circular = uigridlayout(app.Tab2_Circular);
            app.Grid_Circular.ColumnWidth = {'1x'};
            app.Grid_Circular.RowHeight = {'1x'};

            % Create Axes_Circular
            app.Axes_Circular = uiaxes(app.Grid_Circular);
            title(app.Axes_Circular, 'Title')
            xlabel(app.Axes_Circular, 'X')
            ylabel(app.Axes_Circular, 'Y')
            zlabel(app.Axes_Circular, 'Z')
            app.Axes_Circular.Layout.Row = 1;
            app.Axes_Circular.Layout.Column = 1;
            colormap(app.Axes_Circular, 'jet')

            % Create Tab3_Spherical
            app.Tab3_Spherical = uitab(app.Tabs_Pattern);
            app.Tab3_Spherical.Title = 'Spherical';

            % Create Grid_Spherical
            app.Grid_Spherical = uigridlayout(app.Tab3_Spherical);
            app.Grid_Spherical.ColumnWidth = {'1x'};
            app.Grid_Spherical.RowHeight = {'1x'};

            % Create Axes_Spherical
            app.Axes_Spherical = uiaxes(app.Grid_Spherical);
            title(app.Axes_Spherical, 'Title')
            xlabel(app.Axes_Spherical, 'X')
            ylabel(app.Axes_Spherical, 'Y')
            zlabel(app.Axes_Spherical, 'Z')
            app.Axes_Spherical.Layout.Row = 1;
            app.Axes_Spherical.Layout.Column = 1;
            colormap(app.Axes_Spherical, 'jet')

            % Create Tab4_3D
            app.Tab4_3D = uitab(app.Tabs_Pattern);
            app.Tab4_3D.Title = '3D Pattern';

            % Create Grid_3D
            app.Grid_3D = uigridlayout(app.Tab4_3D);
            app.Grid_3D.ColumnWidth = {'1x'};
            app.Grid_3D.RowHeight = {'1x'};

            % Create Axes_3D
            app.Axes_3D = uiaxes(app.Grid_3D);
            title(app.Axes_3D, 'Title')
            xlabel(app.Axes_3D, 'X')
            ylabel(app.Axes_3D, 'Y')
            zlabel(app.Axes_3D, 'Z')
            app.Axes_3D.Layout.Row = 1;
            app.Axes_3D.Layout.Column = 1;
            colormap(app.Axes_3D, 'jet')

            % Create Panel_Cuts
            app.Panel_Cuts = uipanel(app.Tab1_Grid);
            app.Panel_Cuts.Title = 'Antenna Pattern Cut';
            app.Panel_Cuts.Layout.Row = [2 3];
            app.Panel_Cuts.Layout.Column = 2;

            % Create Grid_Cuts
            app.Grid_Cuts = uigridlayout(app.Panel_Cuts);
            app.Grid_Cuts.ColumnWidth = {'1x', 'fit'};
            app.Grid_Cuts.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x'};

            % Create Tabs_Cuts
            app.Tabs_Cuts = uitabgroup(app.Grid_Cuts);
            app.Tabs_Cuts.Layout.Row = [1 6];
            app.Tabs_Cuts.Layout.Column = 1;

            % Create Tab_Polar
            app.Tab_Polar = uitab(app.Tabs_Cuts);
            app.Tab_Polar.Title = 'Polar';

            % Create Grid_Polar
            app.Grid_Polar = uigridlayout(app.Tab_Polar);
            app.Grid_Polar.ColumnWidth = {'1x'};
            app.Grid_Polar.RowHeight = {'1x'};

            % Create Tab_Rect
            app.Tab_Rect = uitab(app.Tabs_Cuts);
            app.Tab_Rect.Title = 'Rectangular';

            % Create Grid_Rect
            app.Grid_Rect = uigridlayout(app.Tab_Rect);
            app.Grid_Rect.ColumnWidth = {'1x'};
            app.Grid_Rect.RowHeight = {'1x'};

            % Create Axes_Rect
            app.Axes_Rect = uiaxes(app.Grid_Rect);
            title(app.Axes_Rect, 'Title')
            xlabel(app.Axes_Rect, 'X')
            ylabel(app.Axes_Rect, 'Y')
            zlabel(app.Axes_Rect, 'Z')
            app.Axes_Rect.Layout.Row = 1;
            app.Axes_Rect.Layout.Column = 1;
            colormap(app.Axes_Rect, 'jet')

            % Create Tab_Filled
            app.Tab_Filled = uitab(app.Tabs_Cuts);
            app.Tab_Filled.Title = 'Filled Polar';

            % Create Grid_Filled
            app.Grid_Filled = uigridlayout(app.Tab_Filled);
            app.Grid_Filled.ColumnWidth = {'1x'};
            app.Grid_Filled.RowHeight = {'1x'};

            % Create Axes_Filled (filled polar cut — Cartesian patch)
            app.Axes_Filled = uiaxes(app.Grid_Filled);
            title(app.Axes_Filled, 'Filled polar cut')
            app.Axes_Filled.Layout.Row = 1;
            app.Axes_Filled.Layout.Column = 1;
            colormap(app.Axes_Filled, 'jet')

            % Create Button2
            app.Button2 = uibutton(app.Grid_Cuts, 'state');
            app.Button2.Text = 'HPBW';
            app.Button2.Layout.Row = 1;
            app.Button2.Layout.Column = 2;

            % Create Label_HPBW
            app.Label_HPBW = uilabel(app.Grid_Cuts);
            app.Label_HPBW.Layout.Row = 2;
            app.Label_HPBW.Layout.Column = 2;
            app.Label_HPBW.Text = '';

            % Create E_TotalCheckBox
            app.E_TotalCheckBox = uicheckbox(app.Grid_Cuts);
            app.E_TotalCheckBox.Text = 'E_Total';
            app.E_TotalCheckBox.Layout.Row = 3;
            app.E_TotalCheckBox.Layout.Column = 2;

            % Create E_RHCPCheckBox
            app.E_RHCPCheckBox = uicheckbox(app.Grid_Cuts);
            app.E_RHCPCheckBox.Text = 'E_RHCP';
            app.E_RHCPCheckBox.Layout.Row = 4;
            app.E_RHCPCheckBox.Layout.Column = 2;

            % Create E_LHCPCheckBox
            app.E_LHCPCheckBox = uicheckbox(app.Grid_Cuts);
            app.E_LHCPCheckBox.Text = 'E_LHCP';
            app.E_LHCPCheckBox.Layout.Row = 5;
            app.E_LHCPCheckBox.Layout.Column = 2;

            % Create ExportCutButton
            app.ExportCutButton = uibutton(app.Grid_Cuts, 'push');
            app.ExportCutButton.Layout.Row = 6;
            app.ExportCutButton.Layout.Column = 2;
            app.ExportCutButton.Text = 'Export Cut';

            % Create TabsData
            app.TabsData = uitabgroup(app.Tab1_Grid);
            app.TabsData.Layout.Row = 4;
            app.TabsData.Layout.Column = [1 3];

            % Create Tab_Output
            app.Tab_Output = uitab(app.TabsData);
            app.Tab_Output.Title = 'Output';

            % Create Grid_Output
            app.Grid_Output = uigridlayout(app.Tab_Output);
            app.Grid_Output.ColumnWidth = {'1x'};
            app.Grid_Output.RowHeight = {'1x'};

            % Create Table_DataOut
            app.Table_DataOut = uitable(app.Grid_Output);
            app.Table_DataOut.ColumnName = {'Theta'; 'Phi'; 'E_Total_dB'; 'E_RCP_dB'; 'E_LCP_dB'; 'E_RCP_Phase'; 'E_LCP_Phase'; 'AR_dB'; 'PLF_dB'; 'Gain_Polarized'; 'EIRP_dBW'; 'PFD_Wm2'; 'E_field_Vm'};
            app.Table_DataOut.ColumnRearrangeable = 'on';
            app.Table_DataOut.RowName = {};
            app.Table_DataOut.Layout.Row = 1;
            app.Table_DataOut.Layout.Column = 1;

            % Create Tab_Input
            app.Tab_Input = uitab(app.TabsData);
            app.Tab_Input.Title = 'Input';

            % Create Grid_Input
            app.Grid_Input = uigridlayout(app.Tab_Input);
            app.Grid_Input.ColumnWidth = {'1x'};
            app.Grid_Input.RowHeight = {'1x'};

            % Create Table_DataIn
            app.Table_DataIn = uitable(app.Grid_Input);
            app.Table_DataIn.ColumnName = {'Theta'; 'Phi'; 'E-TH-DB'; 'E-PH-DB'; 'E-TH-DG'; 'E-PH-DG'};
            app.Table_DataIn.RowName = {};
            app.Table_DataIn.Layout.Row = 1;
            app.Table_DataIn.Layout.Column = 1;

            % Create DropDown_output
            app.DropDown_output = uidropdown(app.Tab1_Grid);
            app.DropDown_output.Items = {'3D View preset,', 'Top View (+Z),', 'Bottom View (+Z),', 'Right View (+Y),', 'Left View (-Y),', 'Front View (+X),', 'Back View (-X)'};
            app.DropDown_output.Layout.Row = 3;
            app.DropDown_output.Layout.Column = 3;
            app.DropDown_output.Value = '3D View preset,';

            % Create Tab2_Batch
            app.Tab2_Batch = uitab(app.TabGroup);
            app.Tab2_Batch.Title = 'Batch Processing';

            % Create Tab2_Grid
            app.Tab2_Grid = uigridlayout(app.Tab2_Batch);
            app.Tab2_Grid.ColumnWidth = {'1x', '1x', '1x'};
            app.Tab2_Grid.RowHeight = {'fit', '1.5x', '1x'};

            % Create Tab2_Panel1
            app.Tab2_Panel1 = uipanel(app.Tab2_Grid);
            app.Tab2_Panel1.Title = 'Inputs & Parameters';
            app.Tab2_Panel1.Layout.Row = 1;
            app.Tab2_Panel1.Layout.Column = [1 3];

            % Create T2P1_Grid
            app.T2P1_Grid = uigridlayout(app.Tab2_Panel1);
            app.T2P1_Grid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.T2P1_Grid.RowHeight = {'1x', '1x', '1x'};

            % Create FormatLabel_2
            app.FormatLabel_2 = uilabel(app.T2P1_Grid);
            app.FormatLabel_2.HorizontalAlignment = 'right';
            app.FormatLabel_2.Layout.Row = 1;
            app.FormatLabel_2.Layout.Column = 1;
            app.FormatLabel_2.Text = 'Format:';

            % Create DropDown_Format_2
            app.DropDown_Format_2 = uidropdown(app.T2P1_Grid);
            app.DropDown_Format_2.Items = {'Eθ, Eϕ [mag_dB,phase°]', 'Eθ, Eϕ [Re,Im]', 'Erh, Elh [mag,phase°]', 'Erh, Elh [Re,Im]', 'Gain Pattern'};
            app.DropDown_Format_2.ItemsData = {'1', '2', '3', '4', '5'};
            app.DropDown_Format_2.Layout.Row = 1;
            app.DropDown_Format_2.Layout.Column = 2;
            app.DropDown_Format_2.Value = '1';

            % Create InputFolderLabel
            app.InputFolderLabel = uilabel(app.T2P1_Grid);
            app.InputFolderLabel.HorizontalAlignment = 'right';
            app.InputFolderLabel.Layout.Row = 1;
            app.InputFolderLabel.Layout.Column = 3;
            app.InputFolderLabel.Text = 'Input Folder:';

            % Create Input_PatternField_Batch
            app.Input_PatternField_Batch = uieditfield(app.T2P1_Grid, 'text');
            app.Input_PatternField_Batch.Editable = 'off';
            app.Input_PatternField_Batch.Placeholder = '(No folder loaded)';
            app.Input_PatternField_Batch.Layout.Row = 1;
            app.Input_PatternField_Batch.Layout.Column = [4 8];

            % Create Button_Load_Batch
            app.Button_Load_Batch = uibutton(app.T2P1_Grid, 'push');
            app.Button_Load_Batch.Layout.Row = 1;
            app.Button_Load_Batch.Layout.Column = 9;
            app.Button_Load_Batch.Text = 'Load';

            % Create Button_Process_Batch
            app.Button_Process_Batch = uibutton(app.T2P1_Grid, 'push');
            app.Button_Process_Batch.Layout.Row = 1;
            app.Button_Process_Batch.Layout.Column = 10;
            app.Button_Process_Batch.Text = 'Process';

            % Create Input_Label_2
            app.Input_Label_2 = uilabel(app.T2P1_Grid);
            app.Input_Label_2.Layout.Row = 2;
            app.Input_Label_2.Layout.Column = [1 6];
            app.Input_Label_2.Text = '';

            % Create Button_ExportInput_2
            app.Button_ExportInput_2 = uibutton(app.T2P1_Grid, 'push');
            app.Button_ExportInput_2.Layout.Row = 2;
            app.Button_ExportInput_2.Layout.Column = 9;
            app.Button_ExportInput_2.Text = 'Export Input';

            % Create Button_ExportOutput_2
            app.Button_ExportOutput_2 = uibutton(app.T2P1_Grid, 'push');
            app.Button_ExportOutput_2.Layout.Row = 2;
            app.Button_ExportOutput_2.Layout.Column = 10;
            app.Button_ExportOutput_2.Text = 'Export Output';

            % Create LossidBLabel_2
            app.LossidBLabel_2 = uilabel(app.T2P1_Grid);
            app.LossidBLabel_2.HorizontalAlignment = 'right';
            app.LossidBLabel_2.Layout.Row = 3;
            app.LossidBLabel_2.Layout.Column = 1;
            app.LossidBLabel_2.Text = 'Loss (dB):';

            % Create Input_Loss_2
            app.Input_Loss_2 = uispinner(app.T2P1_Grid);
            app.Input_Loss_2.Layout.Row = 3;
            app.Input_Loss_2.Layout.Column = 2;

            % Create IncidentWaveARRw_dBLabel_2
            app.IncidentWaveARRw_dBLabel_2 = uilabel(app.T2P1_Grid);
            app.IncidentWaveARRw_dBLabel_2.HorizontalAlignment = 'right';
            app.IncidentWaveARRw_dBLabel_2.Layout.Row = 3;
            app.IncidentWaveARRw_dBLabel_2.Layout.Column = 3;
            app.IncidentWaveARRw_dBLabel_2.Text = 'Rw (Incident Wave AR, dB):';

            % Create Input_Rw_2
            app.Input_Rw_2 = uispinner(app.T2P1_Grid);
            app.Input_Rw_2.Layout.Row = 3;
            app.Input_Rw_2.Layout.Column = 4;
            app.Input_Rw_2.Value = 6;

            % Create TxPowerdBLabel_2
            app.TxPowerdBLabel_2 = uilabel(app.T2P1_Grid);
            app.TxPowerdBLabel_2.HorizontalAlignment = 'right';
            app.TxPowerdBLabel_2.Layout.Row = 3;
            app.TxPowerdBLabel_2.Layout.Column = 5;
            app.TxPowerdBLabel_2.Text = 'Pt (Tx Power):';

            % Create Input_Pt_2
            app.Input_Pt_2 = uispinner(app.T2P1_Grid);
            app.Input_Pt_2.Layout.Row = 3;
            app.Input_Pt_2.Layout.Column = 6;

            % Create DropDown_Pt_2
            app.DropDown_Pt_2 = uidropdown(app.T2P1_Grid);
            app.DropDown_Pt_2.Items = {'dB', 'dBm', 'Watts'};
            app.DropDown_Pt_2.Layout.Row = 3;
            app.DropDown_Pt_2.Layout.Column = 7;
            app.DropDown_Pt_2.Value = 'dB';

            % Create DistanceLabel_2
            app.DistanceLabel_2 = uilabel(app.T2P1_Grid);
            app.DistanceLabel_2.HorizontalAlignment = 'right';
            app.DistanceLabel_2.Layout.Row = 3;
            app.DistanceLabel_2.Layout.Column = 8;
            app.DistanceLabel_2.Text = 'R (E-field Range, m):';

            % Create Input_Distance_2
            app.Input_Distance_2 = uispinner(app.T2P1_Grid);
            app.Input_Distance_2.Layout.Row = 3;
            app.Input_Distance_2.Layout.Column = 9;
            app.Input_Distance_2.Value = 1;

            % Create DropDown_Orientation_2
            app.DropDown_Orientation_2 = uidropdown(app.T2P1_Grid);
            app.DropDown_Orientation_2.Items = {'Orientation:', '+Z', '-Z', '+X', '-X', '+Y', '-Y'};
            app.DropDown_Orientation_2.Layout.Row = 3;
            app.DropDown_Orientation_2.Layout.Column = 10;
            app.DropDown_Orientation_2.Value = 'Orientation:';

            % Create Tree2
            app.Tree2 = uitree(app.Tab2_Grid, 'checkbox');
            app.Tree2.Layout.Row = [2 3];
            app.Tree2.Layout.Column = 1;

            % Create Node_2
            app.Node_2 = uitreenode(app.Tree2);
            app.Node_2.Text = 'Node';

            % Create Node2_2
            app.Node2_2 = uitreenode(app.Node_2);
            app.Node2_2.Text = 'Node2';

            % Create Node3_2
            app.Node3_2 = uitreenode(app.Node_2);
            app.Node3_2.Text = 'Node3';

            % Create Node4_2
            app.Node4_2 = uitreenode(app.Node_2);
            app.Node4_2.Text = 'Node4';

            % Create Tab3_Coverage
            app.Tab3_Coverage = uitab(app.TabGroup);
            app.Tab3_Coverage.Title = 'Coverage Analysis';

            % Create Tab3_Grid
            app.Tab3_Grid = uigridlayout(app.Tab3_Coverage);
            app.Tab3_Grid.ColumnWidth = {'1x', '1x', '1x'};
            app.Tab3_Grid.RowHeight = {'1x', '1x', '1x'};

            % Create UIAxes
            app.UIAxes = uiaxes(app.Tab3_Grid);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Layout.Row = [2 3];
            app.UIAxes.Layout.Column = 2;

            % Create Tab3_Panel1
            app.Tab3_Panel1 = uipanel(app.Tab3_Grid);
            app.Tab3_Panel1.Title = 'Inputs & Parameters';
            app.Tab3_Panel1.Layout.Row = 1;
            app.Tab3_Panel1.Layout.Column = [1 3];

            % Create T3P1_Grid
            app.T3P1_Grid = uigridlayout(app.Tab3_Panel1);
            app.T3P1_Grid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.T3P1_Grid.RowHeight = {'1x', '1x', '1x'};

            % Create GainPatternLabel
            app.GainPatternLabel = uilabel(app.T3P1_Grid);
            app.GainPatternLabel.HorizontalAlignment = 'right';
            app.GainPatternLabel.Layout.Row = 1;
            app.GainPatternLabel.Layout.Column = 2;
            app.GainPatternLabel.Text = 'Gain Pattern:';

            % Create Input_PatternField_Coverage
            app.Input_PatternField_Coverage = uieditfield(app.T3P1_Grid, 'text');
            app.Input_PatternField_Coverage.Editable = 'off';
            app.Input_PatternField_Coverage.Placeholder = '(No file loaded)';
            app.Input_PatternField_Coverage.Layout.Row = 1;
            app.Input_PatternField_Coverage.Layout.Column = [3 7];

            % Create Button_Load_Coverage
            app.Button_Load_Coverage = uibutton(app.T3P1_Grid, 'push');
            app.Button_Load_Coverage.Layout.Row = 1;
            app.Button_Load_Coverage.Layout.Column = 8;
            app.Button_Load_Coverage.Text = 'Load';

            % Create Button_Process_Coverage
            app.Button_Process_Coverage = uibutton(app.T3P1_Grid, 'push');
            app.Button_Process_Coverage.Layout.Row = 1;
            app.Button_Process_Coverage.Layout.Column = 9;
            app.Button_Process_Coverage.Text = 'Process';

            % Create Button_ExportOutput_Coverage
            app.Button_ExportOutput_Coverage = uibutton(app.T3P1_Grid, 'push');
            app.Button_ExportOutput_Coverage.Layout.Row = 2;
            app.Button_ExportOutput_Coverage.Layout.Column = 9;
            app.Button_ExportOutput_Coverage.Text = 'Export Output';

            % Create ButtonGroup_Coverage
            app.ButtonGroup_Coverage = uibuttongroup(app.T3P1_Grid);
            app.ButtonGroup_Coverage.Title = 'Coverage Type';
            app.ButtonGroup_Coverage.Layout.Row = [1 2];
            app.ButtonGroup_Coverage.Layout.Column = 1;

            % Create Button_Conical
            app.Button_Conical = uiradiobutton(app.ButtonGroup_Coverage);
            app.Button_Conical.Text = 'Conical';
            app.Button_Conical.Position = [11 57 65 22];

            % Create Button_Spherical
            app.Button_Spherical = uiradiobutton(app.ButtonGroup_Coverage);
            app.Button_Spherical.Text = 'Spherical';
            app.Button_Spherical.Position = [11 79 72 22];
            app.Button_Spherical.Value = true;

            % Create DropDown_covOrientation
            app.DropDown_covOrientation = uidropdown(app.T3P1_Grid);
            app.DropDown_covOrientation.Items = {'Orientation:', '1. Forward (+X)', '2. Aft (-X)', '3. Starboard (+Y)', '4. Port (-Y)', '5. Overhead (+Z)', '6. Deck (-Z)', '7. Arbitrary Orientation'};
            app.DropDown_covOrientation.ItemsData = {'1', '2', '3', '4', '5', '6', '7', '8'};
            app.DropDown_covOrientation.Layout.Row = 3;
            app.DropDown_covOrientation.Layout.Column = 1;
            app.DropDown_covOrientation.Value = '1';

            % Create ThreshMindBLabel
            app.ThreshMindBLabel = uilabel(app.T3P1_Grid);
            app.ThreshMindBLabel.HorizontalAlignment = 'right';
            app.ThreshMindBLabel.Layout.Row = 2;
            app.ThreshMindBLabel.Layout.Column = 2;
            app.ThreshMindBLabel.Text = 'Thresh Min (dB):';

            % Create Spinner_threshMin
            app.Spinner_threshMin = uispinner(app.T3P1_Grid);
            app.Spinner_threshMin.Limits = [-250 100];
            app.Spinner_threshMin.Layout.Row = 2;
            app.Spinner_threshMin.Layout.Column = 3;
            app.Spinner_threshMin.Value = -30;

            % Create ThreshMindBLabel_2
            app.ThreshMindBLabel_2 = uilabel(app.T3P1_Grid);
            app.ThreshMindBLabel_2.HorizontalAlignment = 'right';
            app.ThreshMindBLabel_2.Layout.Row = 2;
            app.ThreshMindBLabel_2.Layout.Column = 4;
            app.ThreshMindBLabel_2.Text = 'Thresh Min (dB):';

            % Create Spinner_threshMax
            app.Spinner_threshMax = uispinner(app.T3P1_Grid);
            app.Spinner_threshMax.Limits = [-250 100];
            app.Spinner_threshMax.Layout.Row = 2;
            app.Spinner_threshMax.Layout.Column = 5;
            app.Spinner_threshMax.Value = 10;

            % Create StepLabel
            app.StepLabel = uilabel(app.T3P1_Grid);
            app.StepLabel.HorizontalAlignment = 'right';
            app.StepLabel.Layout.Row = 2;
            app.StepLabel.Layout.Column = 6;
            app.StepLabel.Text = 'Step (dB):';

            % Create Spinner_threshStep
            app.Spinner_threshStep = uispinner(app.T3P1_Grid);
            app.Spinner_threshStep.Limits = [0.01 10];
            app.Spinner_threshStep.Layout.Row = 2;
            app.Spinner_threshStep.Layout.Column = 7;
            app.Spinner_threshStep.Value = 0.5;

            % Create Cone0Label
            app.Cone0Label = uilabel(app.T3P1_Grid);
            app.Cone0Label.HorizontalAlignment = 'right';
            app.Cone0Label.Enable = 'off';
            app.Cone0Label.Layout.Row = 3;
            app.Cone0Label.Layout.Column = 2;
            app.Cone0Label.Text = 'Cone θ0(°):';

            % Create Spinner_coneTH
            app.Spinner_coneTH = uispinner(app.T3P1_Grid);
            app.Spinner_coneTH.Limits = [0 360];
            app.Spinner_coneTH.Enable = 'off';
            app.Spinner_coneTH.Layout.Row = 3;
            app.Spinner_coneTH.Layout.Column = 3;

            % Create ConeLabel
            app.ConeLabel = uilabel(app.T3P1_Grid);
            app.ConeLabel.HorizontalAlignment = 'right';
            app.ConeLabel.Enable = 'off';
            app.ConeLabel.Layout.Row = 3;
            app.ConeLabel.Layout.Column = 4;
            app.ConeLabel.Text = 'Cone φ(°)';

            % Create Spinner_conePH
            app.Spinner_conePH = uispinner(app.T3P1_Grid);
            app.Spinner_conePH.Limits = [0 360];
            app.Spinner_conePH.Enable = 'off';
            app.Spinner_conePH.Layout.Row = 3;
            app.Spinner_conePH.Layout.Column = 5;

            % Create CongAngleLabel
            app.CongAngleLabel = uilabel(app.T3P1_Grid);
            app.CongAngleLabel.HorizontalAlignment = 'right';
            app.CongAngleLabel.Enable = 'off';
            app.CongAngleLabel.Layout.Row = 3;
            app.CongAngleLabel.Layout.Column = 6;
            app.CongAngleLabel.Text = 'Cone Angle α (°):';

            % Create Spinner_coneAng
            app.Spinner_coneAng = uispinner(app.T3P1_Grid);
            app.Spinner_coneAng.Limits = [0 360];
            app.Spinner_coneAng.Enable = 'off';
            app.Spinner_coneAng.Layout.Row = 3;
            app.Spinner_coneAng.Layout.Column = 7;
            app.Spinner_coneAng.Value = 45;

            % Create Button_Clear
            app.Button_Clear = uibutton(app.T3P1_Grid, 'push');
            app.Button_Clear.Layout.Row = 2;
            app.Button_Clear.Layout.Column = 8;
            app.Button_Clear.Text = 'Clear';

            % Create Tree
            app.Tree = uitree(app.Tab3_Grid, 'checkbox');
            app.Tree.Layout.Row = [2 3];
            app.Tree.Layout.Column = 1;

            % Create Node
            app.Node = uitreenode(app.Tree);
            app.Node.Text = 'Node';

            % Create Node2
            app.Node2 = uitreenode(app.Node);
            app.Node2.Text = 'Node2';

            % Create Node3
            app.Node3 = uitreenode(app.Node);
            app.Node3.Text = 'Node3';

            % Create Node4
            app.Node4 = uitreenode(app.Node);
            app.Node4.Text = 'Node4';

            % Create UITable
            app.UITable = uitable(app.Tab3_Grid);
            app.UITable.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.UITable.RowName = {};
            app.UITable.Layout.Row = [2 3];
            app.UITable.Layout.Column = 3;

            % Create Tab4_Combine
            app.Tab4_Combine = uitab(app.TabGroup);
            app.Tab4_Combine.Title = 'Combine Patterns';

            % Create Tab2_Grid_2
            app.Tab2_Grid_2 = uigridlayout(app.Tab4_Combine);
            app.Tab2_Grid_2.ColumnWidth = {'0.28x', '1x', '1x'};
            app.Tab2_Grid_2.RowHeight = {'fit', '2x', '2x', '2x', 'fit', 'fit', 'fit'};

            % Create Tab2_Panel1_2
            app.Tab2_Panel1_2 = uipanel(app.Tab2_Grid_2);
            app.Tab2_Panel1_2.Title = 'Inputs & Parameters';
            app.Tab2_Panel1_2.Layout.Row = 1;
            app.Tab2_Panel1_2.Layout.Column = [1 3];

            % Create T2P1_Grid_2
            app.T2P1_Grid_2 = uigridlayout(app.Tab2_Panel1_2);
            app.T2P1_Grid_2.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.T2P1_Grid_2.RowHeight = {'1x', '1x', '1x'};

            % Create Button_LoadCombine
            app.Button_LoadCombine = uibutton(app.T2P1_Grid_2, 'push');
            app.Button_LoadCombine.Layout.Row = 1;
            app.Button_LoadCombine.Layout.Column = [1 9];
            app.Button_LoadCombine.Text = 'Load';

            % Create Button_ClearCombine
            app.Button_ClearCombine = uibutton(app.T2P1_Grid_2, 'push');
            app.Button_ClearCombine.Layout.Row = 1;
            app.Button_ClearCombine.Layout.Column = 10;
            app.Button_ClearCombine.Text = 'Clear';

            % Create Button_Combine
            app.Button_Combine = uibutton(app.T2P1_Grid_2, 'push');
            app.Button_Combine.Layout.Row = 2;
            app.Button_Combine.Layout.Column = 10;
            app.Button_Combine.Text = 'Combine Patterns';

            % Create Button_ExportCombined
            app.Button_ExportCombined = uibutton(app.T2P1_Grid_2, 'push');
            app.Button_ExportCombined.Layout.Row = 3;
            app.Button_ExportCombined.Layout.Column = 10;
            app.Button_ExportCombined.Text = 'Export Combined Pattern';

            % Create Metode1CombinePowersEfieldsLabel
            app.Metode1CombinePowersEfieldsLabel = uilabel(app.T2P1_Grid_2);
            app.Metode1CombinePowersEfieldsLabel.Layout.Row = [2 3];
            app.Metode1CombinePowersEfieldsLabel.Layout.Column = [1 3];
            app.Metode1CombinePowersEfieldsLabel.Text = 'Choose combine mode below.';

            % Create ButtonGroup_CombineMethod
            app.ButtonGroup_CombineMethod = uibuttongroup(app.T2P1_Grid_2);
            app.ButtonGroup_CombineMethod.Title = 'Combine Method';
            app.ButtonGroup_CombineMethod.Layout.Row = [2 3];
            app.ButtonGroup_CombineMethod.Layout.Column = 4;

            % Create RadioButton_Method1
            app.RadioButton_Method1 = uiradiobutton(app.ButtonGroup_CombineMethod);
            app.RadioButton_Method1.Text = 'Coherent sum (E-fields)';
            app.RadioButton_Method1.Position = [11 134 69 22];
            app.RadioButton_Method1.Value = true;

            % Create RadioButton_Method2
            app.RadioButton_Method2 = uiradiobutton(app.ButtonGroup_CombineMethod);
            app.RadioButton_Method2.Text = 'Best source (planned)';
            app.RadioButton_Method2.Position = [11 112 69 22];

            % Create RadioButton_Method3
            app.RadioButton_Method3 = uiradiobutton(app.ButtonGroup_CombineMethod);
            app.RadioButton_Method3.Text = 'Regional masking (θ–φ)';
            app.RadioButton_Method3.Position = [11 90 69 22];

            % Create Tree2_2
            app.Tree2_2 = uitree(app.Tab2_Grid_2, 'checkbox');
            app.Tree2_2.Layout.Row = [2 4];
            app.Tree2_2.Layout.Column = 1;

            % Combine preview (patterns + combined result)
            app.Combine_Viz_Panel = uipanel(app.Tab2_Grid_2);
            app.Combine_Viz_Panel.Title = 'Preview (gain on sphere)';
            app.Combine_Viz_Panel.Layout.Row = [2 4];
            app.Combine_Viz_Panel.Layout.Column = [2 3];

            % Create Node_3
            app.Node_3 = uitreenode(app.Tree2_2);
            app.Node_3.Text = 'Node';

            % Create Node2_3
            app.Node2_3 = uitreenode(app.Node_3);
            app.Node2_3.Text = 'Node2';

            % Create Node3_3
            app.Node3_3 = uitreenode(app.Node_3);
            app.Node3_3.Text = 'Node3';

            % Create Node4_3
            app.Node4_3 = uitreenode(app.Node_3);
            app.Node4_3.Text = 'Node4';

            app.Label_MaskPartitionAxis = uilabel(app.Tab2_Grid_2);
            app.Label_MaskPartitionAxis.Layout.Row = 5;
            app.Label_MaskPartitionAxis.Layout.Column = 1;
            app.Label_MaskPartitionAxis.HorizontalAlignment = 'right';
            app.Label_MaskPartitionAxis.Text = 'Default bands split';
            app.Label_MaskPartitionAxis.Visible = 'off';

            app.DropDown_MaskPartitionAxis = uidropdown(app.Tab2_Grid_2);
            app.DropDown_MaskPartitionAxis.Layout.Row = 5;
            app.DropDown_MaskPartitionAxis.Layout.Column = [2 3];
            app.DropDown_MaskPartitionAxis.Items = {'Phi / azimuth only', 'Theta / polar only', 'Custom sectors (free table)'};
            app.DropDown_MaskPartitionAxis.Value = 'Phi / azimuth only';
            app.DropDown_MaskPartitionAxis.Visible = 'off';

            app.Table_MaskCombine = uitable(app.Tab2_Grid_2);
            app.Table_MaskCombine.Layout.Row = 6;
            app.Table_MaskCombine.Layout.Column = [1 3];
            app.Table_MaskCombine.ColumnName = {'Pattern', 'θ min (°)', 'θ max (°)', 'φ min (°)', 'φ max (°)'};
            app.Table_MaskCombine.ColumnEditable = [false true true true true];
            app.Table_MaskCombine.Visible = 'off';

            app.Label_MaskRemainder = uilabel(app.Tab2_Grid_2);
            app.Label_MaskRemainder.Layout.Row = 7;
            app.Label_MaskRemainder.Layout.Column = [1 3];
            app.Label_MaskRemainder.WordWrap = 'on';
            app.Label_MaskRemainder.Text = '';
            app.Label_MaskRemainder.Visible = 'off';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = APA_v01

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end