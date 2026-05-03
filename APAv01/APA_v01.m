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
        Label_AzEl_Spherical          matlab.ui.control.Label
        Axes_Spherical                matlab.ui.control.UIAxes
        Tab4_3D                       matlab.ui.container.Tab
        Grid_3D                       matlab.ui.container.GridLayout
        Label_AzEl_3D                 matlab.ui.control.Label
        Axes_3D                       matlab.ui.control.UIAxes
        Panel_PlotControls            matlab.ui.container.Panel
        Grid_PlotCtrl                 matlab.ui.container.GridLayout
        CB_ShowGrids                  matlab.ui.control.CheckBox
        CB_ShowPeakMarker             matlab.ui.control.CheckBox
        DropDown_ViewPreset           matlab.ui.control.DropDown
        ViewPresetLabel               matlab.ui.control.Label
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
        DropDown_CutMode              matlab.ui.control.DropDown
        CutmodeLabel                  matlab.ui.control.Label
        CuttypeDropDownLabel          matlab.ui.control.Label
        DropDown_Component            matlab.ui.control.DropDown
        ComponentLabel                matlab.ui.control.Label
        Tab1_Panel1                   matlab.ui.container.Panel
        T1P1_Grid                     matlab.ui.container.GridLayout
        RotationLabel                 matlab.ui.control.Label
        Button_Rotation               matlab.ui.control.Button
        DestinationDropDown_2         matlab.ui.control.DropDown
        DestinationDropDown_2Label    matlab.ui.control.Label
        DestinationDropDown           matlab.ui.control.DropDown
        DestinationDropDownLabel      matlab.ui.control.Label
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
        Panel_BatchInspect            matlab.ui.container.Panel
        Grid_BatchInspect             matlab.ui.container.GridLayout
        Label_BatchInfo               matlab.ui.control.Label
        DropDown_BatchView            matlab.ui.control.DropDown
        DropDown_BatchComp            matlab.ui.control.DropDown
        Axes_BatchInspect             matlab.ui.control.UIAxes
        DropDown_BatchExportFmt       matlab.ui.control.DropDown
        CB_BatchSavePlots             matlab.ui.control.CheckBox
        CB_BatchGain3dOnly            matlab.ui.control.CheckBox
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
        Button                        matlab.ui.control.Button
        CB_covGrid                    matlab.ui.control.CheckBox
        CB_covLegend                  matlab.ui.control.CheckBox
        Spinner_covLineWidth          matlab.ui.control.Spinner
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
        Metode1CombinePowersEfieldsLabel  matlab.ui.control.Label
        Button_ExportCombined         matlab.ui.control.Button
        Button_Combine                matlab.ui.control.Button
        Button_LoadCombine            matlab.ui.control.Button
        % Tab 4: combination-method selection + per-pattern mask limits
        RadioGroup_CombineMethod      matlab.ui.container.ButtonGroup
        Radio_Coherent                matlab.ui.control.RadioButton
        Radio_Incoherent              matlab.ui.control.RadioButton
        Radio_Envelope                matlab.ui.control.RadioButton
        Radio_Masked                  matlab.ui.control.RadioButton
        Panel_Masking                 matlab.ui.container.Panel
        Grid_Masking                  matlab.ui.container.GridLayout
        Label_MaskingHelp             matlab.ui.control.Label
        Label_MaskLeftoverMode        matlab.ui.control.Label
        DropDown_MaskLeftoverMode     matlab.ui.control.DropDown
        Table_Masks                   matlab.ui.control.Table
    end

    
    properties (Access = private)
        pax        matlab.graphics.axis.PolarAxes  % Polar axes for cuts
        P_in       struct                          % Loaded canonical pattern (Tab 1, current state)
        P_in_orig  struct                          % Original unrotated pattern (Tab 1, snapshot)
        R_cum      double = eye(3)                 % Cumulative rotation applied to P_in_orig
        SyncingView logical = false                % Re-entrance guard for the cross-axes view sync
        BoresightAxis char    = '+Z'               % Detected dominant boresight axis ('+X','-X', ... '+Z','-Z')
        R_out      struct                          % Processed result (Tab 1)
        Batch      cell                            % Batch entries: {struct('file',..,'P',..,'R',..)}
        RootFolder char                            % Tab 2 root folder
        Lib        cell                            % All patterns currently in memory (Tabs 3 & 4)
        LibNames   cell                            % Display names for Lib entries
        CovThr     double                          % Last coverage threshold sweep
        CovData    double                          % Last coverage matrix (Nthr x Npat)
        CovNames   cell                            % Last coverage column names
        Combined   struct                          % Last combined pattern
        LoadOpts   struct                          % Options forwarded to parsers (e.g. gainCol)
        CovRuns    cell = {}                       % Coverage runs: struct('patIdx','mode','params','thr','cov','name','visible')
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            here = fileparts(mfilename('fullpath'));
            addpath(genpath(fullfile(here,'lib')));

            app.pax = polaraxes(app.Grid_Polar);
            cla(app.pax,"reset");
            reset(app.pax);
            app.pax.ThetaZeroLocation = 'top';
            app.pax.ThetaDir = 'clockwise';
            

            app.Table_DataIn.RowName  = 'numbered';
            app.Table_DataOut.RowName = 'numbered';
            app.Lib       = {};
            app.LibNames  = {};
            app.Batch     = {};
            app.P_in      = struct([]);
            app.P_in_orig = struct([]);
            app.R_cum     = eye(3);
            app.R_out     = struct([]);

            populateAngleDropdowns(app);
            registerCallbacks(app);
            updateConicalEnable(app);
        end

        function populateAngleDropdowns(app)
            thList = arrayfun(@(x) sprintf('%g', x), 0:5:180, 'UniformOutput', false);
            phList = arrayfun(@(x) sprintf('%g', x), 0:5:360, 'UniformOutput', false);
            app.SourceDropDown.Items        = thList; app.SourceDropDown.Value        = '0';
            app.DestinationDropDown.Items   = thList; app.DestinationDropDown.Value   = '0';
            app.SourceDropDown_2.Items      = phList; app.SourceDropDown_2.Value      = '0';
            app.DestinationDropDown_2.Items = phList; app.DestinationDropDown_2.Value = '0';

            app.DropDown_output.Items = {'Filter Output:','All','Theta cut at peak','Phi cut at peak'};
            app.DropDown_Step.Items   = {'Auto','STEP: 0.5°','STEP: 1°','STEP: 2°','STEP: 5°'};
            app.DropDown_Step.Value   = 'Auto';

            % Default all three cut components visible.
            app.E_TotalCheckBox.Value = true;
            app.E_RHCPCheckBox.Value  = true;
            app.E_LHCPCheckBox.Value  = true;
        end

        % ---------------------------------------------------------------
        %                       CALLBACK REGISTRATION
        % ---------------------------------------------------------------
        function registerCallbacks(app)
            % Tab 1 - Single
            app.Button_Load_Single.ButtonPushedFcn          = @(s,e) onLoadSingle(app);
            app.Button_Process_Single.ButtonPushedFcn       = @(s,e) onProcessSingle(app);
            app.Button_ExportInput.ButtonPushedFcn          = @(s,e) onExportInput(app);
            app.Button_ExportOutput.ButtonPushedFcn         = @(s,e) onExportOutput(app);
            app.ExportCutButton.ButtonPushedFcn             = @(s,e) onExportCut(app);
            app.Button_Rotation.ButtonPushedFcn             = @(s,e) onRotate(app);
            app.ComputeCoverageButton.ButtonPushedFcn       = @(s,e) onComputeCoverageFromTab1(app);
            app.Button2.ValueChangedFcn                     = @(s,e) onHPBW(app);
            app.DropDown_Orientation.ValueChangedFcn        = @(s,e) onOrientationPreset(app);

            app.DropDown_Component.ValueChangedFcn          = @(s,e) refreshTab1Plots(app);
            app.DropDown_CutType.ValueChangedFcn            = @(s,e) onCutControlsChanged(app);
            app.Input_Cut_Value.ValueChangedFcn             = @(s,e) onCutControlsChanged(app);
            app.DropDown_CutMode.ValueChangedFcn            = @(s,e) onCutModeChanged(app);
            app.Input_Plot_Cmin.ValueChangedFcn             = @(s,e) refreshTab1Plots(app);
            app.Input_Plot_Cmax.ValueChangedFcn             = @(s,e) refreshTab1Plots(app);
            app.Input_Plot_Cstep.ValueChangedFcn            = @(s,e) refreshTab1Plots(app);
            app.DViewAzSpinner.ValueChangedFcn              = @(s,e) onViewSpinnerChanged(app);
            app.DviewElSpinner.ValueChangedFcn              = @(s,e) onViewSpinnerChanged(app);
            app.E_TotalCheckBox.ValueChangedFcn             = @(s,e) refreshTab1Plots(app);
            app.E_RHCPCheckBox.ValueChangedFcn              = @(s,e) refreshTab1Plots(app);
            app.E_LHCPCheckBox.ValueChangedFcn              = @(s,e) refreshTab1Plots(app);
            app.CB_ShowGrids.ValueChangedFcn                = @(s,e) refreshTab1Plots(app);
            app.CB_ShowPeakMarker.ValueChangedFcn           = @(s,e) refreshTab1Plots(app);
            app.DropDown_ViewPreset.ValueChangedFcn         = @(s,e) onViewPresetChanged(app);

            % Tab 2 - Batch
            app.Button_Load_Batch.ButtonPushedFcn           = @(s,e) onLoadBatch(app);
            app.Button_Process_Batch.ButtonPushedFcn        = @(s,e) onProcessBatch(app);
            app.Button_ExportInput_2.ButtonPushedFcn        = @(s,e) onExportBatchInput(app);
            app.Button_ExportOutput_2.ButtonPushedFcn       = @(s,e) onExportBatchOutput(app);
            app.Tree2.SelectionChangedFcn                   = @(s,e) onBatchTreeSelect(app);
            app.DropDown_BatchView.ValueChangedFcn          = @(s,e) onBatchInspectRefresh(app);
            app.DropDown_BatchComp.ValueChangedFcn          = @(s,e) onBatchInspectRefresh(app);

            % Tab 3 - Coverage
            app.Button_Load_Coverage.ButtonPushedFcn        = @(s,e) onLoadCoverageFile(app);
            app.Button_Process_Coverage.ButtonPushedFcn     = @(s,e) onComputeCoverage(app);
            app.Button_ExportOutput_Coverage.ButtonPushedFcn= @(s,e) onExportCoverage(app);
            app.ButtonGroup_Coverage.SelectionChangedFcn    = @(s,e) updateConicalEnable(app);
            app.Button.ButtonPushedFcn                      = @(s,e) onClearCoverageSel(app);
            app.Button.Text                                 = 'Clear';
            app.Tree.CheckedNodesChangedFcn                 = @(s,e) refreshCoverageDisplay(app);
            app.Tree.DoubleClickedFcn                       = @(s,e) onTreeDoubleClick(app, s, e);

            % Tab 4 - Combine
            app.Button_LoadCombine.ButtonPushedFcn          = @(s,e) onRefreshLibrary(app);
            app.Button_Combine.ButtonPushedFcn              = @(s,e) onCombine(app);
            app.Button_ExportCombined.ButtonPushedFcn       = @(s,e) onExportCombined(app);
            app.RadioGroup_CombineMethod.SelectionChangedFcn= @(s,e) onCombineMethodChanged(app);
            app.Tree2_2.CheckedNodesChangedFcn              = @(s,e) onMaskingPatternsChanged(app);
            app.Table_Masks.CellEditCallback                = @(s,e) onMaskTableEdited(app);
            app.DropDown_MaskLeftoverMode.ValueChangedFcn   = @(s,e) onMaskLeftoverModeChanged(app);
        end

        % ---------------------------------------------------------------
        %                       PARAMETER HELPERS
        % ---------------------------------------------------------------
        function p = getProcessParams(app, batch)
            if nargin<2; batch = false; end
            if batch
                Pt   = app.Input_Pt_2.Value;
                unit = app.DropDown_Pt_2.Value;
                p.Loss_dB = app.Input_Loss_2.Value;
                p.Rw_dB   = app.Input_Rw_2.Value;
                p.R_m     = app.Input_Distance_2.Value;
            else
                Pt   = app.Input_Pt.Value;
                unit = app.DropDown_Pt.Value;
                p.Loss_dB = app.Input_Loss.Value;
                p.Rw_dB   = app.Input_Rw.Value;
                p.R_m     = app.Input_Distance.Value;
            end
            switch unit
                case 'dBW';   p.Pt_W = 10^(Pt/10);
                case 'dBm';   p.Pt_W = 10^((Pt-30)/10);
                case 'Watts'; p.Pt_W = max(Pt,eps);
                otherwise;    p.Pt_W = max(Pt,eps);
            end
        end

        function ctrl = getPlotCtrl(app)
            ctrl.Cmin  = app.Input_Plot_Cmin.Value;
            ctrl.Cmax  = app.Input_Plot_Cmax.Value;
            ctrl.Cstep = app.Input_Plot_Cstep.Value;
            ctrl.Az    = app.DViewAzSpinner.Value;
            ctrl.El    = app.DviewElSpinner.Value;
            if ctrl.Cmax <= ctrl.Cmin
                ctrl.Cmax = ctrl.Cmin + 1;
            end
            try
                ctrl.CutValue = app.Input_Cut_Value.Value;
            catch
                ctrl.CutValue = 0;
            end
            try
                ctrl.ShowGrids = logical(app.CB_ShowGrids.Value);
            catch
                ctrl.ShowGrids = true;
            end
            try
                ctrl.ShowPeakMarker = logical(app.CB_ShowPeakMarker.Value);
            catch
                ctrl.ShowPeakMarker = false;
            end
            % The HPBW overlay is state-driven: only drawn when the HPBW
            % toggle button is currently pressed.
            try
                ctrl.ShowHPBW = logical(app.Button2.Value);
            catch
                ctrl.ShowHPBW = false;
            end
            % View-change callback used by 3D plots to push rotations back
            % into the Az/El spinners AND to keep the two 3D axes in sync.
            ctrl.viewChangedCb = @(ax, v) onViewChanged(app, ax, v);
        end

        function onViewChanged(app, srcAx, v)
            % Lightweight handler for live 3D rotations: keeps the two 3D
            % axes synchronised AND mirrors the current [az el] into the
            % spinner inputs.  The function is purposely cheap because it
            % fires at every pixel of an interactive rotation.
            if nargin < 3 || numel(v) < 2; return; end

            % Re-entrance guard: when we programmatically push the view
            % into the OTHER axes below, that axes' own View listener will
            % fire and we don't want it to bounce back here.
            if app.SyncingView; return; end
            app.SyncingView = true;
            cln = onCleanup(@() setSyncFlag(app,false));

            % Spinners: only assign when the integer-rounded value really
            % changes, otherwise we burn a UI redraw on every micro-step.
            azNew = round(v(1));
            elNew = round(v(2));
            try
                if app.DViewAzSpinner.Value ~= azNew
                    app.DViewAzSpinner.Value = azNew;
                end
                if app.DviewElSpinner.Value ~= elNew
                    app.DviewElSpinner.Value = elNew;
                end
            catch
            end

            % Any manual rotation silently reverts the preset dropdown.
            try
                if ~strcmp(app.DropDown_ViewPreset.Value, 'Custom')
                    app.DropDown_ViewPreset.Value = 'Custom';
                end
            catch
            end

            % Cross-plot view sync.  Push the view into the OTHER axes
            % only when the angular difference is meaningful (>0.5 deg),
            % so micro-mouse jitter doesn't trigger a re-render of a 3D
            % surface on every pixel of the drag.
            try
                if isgraphics(srcAx) && isvalid(srcAx)
                    if srcAx == app.Axes_3D && isvalid(app.Axes_Spherical)
                        other = app.Axes_Spherical;
                    elseif srcAx == app.Axes_Spherical && isvalid(app.Axes_3D)
                        other = app.Axes_3D;
                    else
                        other = [];
                    end
                    if ~isempty(other)
                        cur = get(other,'View');
                        if any(abs(cur - v(:).') > 0.5)
                            view(other, v(1), v(2));
                        end
                    end
                end
            catch
            end
        end

        function setSyncFlag(app, val)
            try; app.SyncingView = val; catch; end
        end

        function onViewSpinnerChanged(app)
            % Lightweight handler bound to the Az / El uispinners.  Only
            % updates the camera angle on the two existing 3D axes - it
            % does NOT replot the surfaces.  Replotting on every spinner
            % click was the main cause of the perceived UI lag.
            try
                az = app.DViewAzSpinner.Value;
                el = app.DviewElSpinner.Value;
                app.SyncingView = true;
                cln = onCleanup(@() setSyncFlag(app,false));
                if isgraphics(app.Axes_Spherical) && isvalid(app.Axes_Spherical)
                    view(app.Axes_Spherical, az, el);
                end
                if isgraphics(app.Axes_3D) && isvalid(app.Axes_3D)
                    view(app.Axes_3D, az, el);
                end
                if ~strcmp(app.DropDown_ViewPreset.Value, 'Custom')
                    app.DropDown_ViewPreset.Value = 'Custom';
                end
            catch
            end
        end

        function onViewPresetChanged(app)
            % Snap the 3D view to an orthographic preset and refresh the
            % 3D plots.  The Az/El spinners are kept in sync with the view.
            preset = app.DropDown_ViewPreset.Value;
            switch preset
                case '+X (front)',  az =  90; el =  0;
                case '-X (back)',   az = -90; el =  0;
                case '+Y (right)',  az = 180; el =  0;
                case '-Y (left)',   az =   0; el =  0;
                case '+Z (top)',    az =   0; el = 90;
                case '-Z (bottom)', az =   0; el = -90;
                case 'Iso',         az = -37.5; el = 30;
                otherwise,          return;                   % 'Custom'
            end
            try
                app.DViewAzSpinner.Value = az;
                app.DviewElSpinner.Value = el;
            catch
            end
            % View-only update; no need to redraw the surfaces.
            onViewSpinnerChanged(app);
        end

        function onCutModeChanged(app)
            % Switching between E-Plane / H-Plane / Custom updates the
            % Cut Type and Cut Value controls so the cut plot follows the
            % auto-derived plane (or unlocks them in 'Custom').
            applyCutMode(app);
            refreshTab1Plots(app);
        end

        function onCutControlsChanged(app)
            % If the user manually edits Cut Type or Cut Value, drop us
            % out of E-Plane / H-Plane mode (their values would otherwise
            % be overwritten on the next refresh).
            if ~strcmp(app.DropDown_CutMode.Value, 'Custom')
                APA_v01.setDropDownSafe(app.DropDown_CutMode, 'Custom');
            end
            refreshTab1Plots(app);
        end

        function applyCutMode(app)
            mode = app.DropDown_CutMode.Value;
            switch mode
                case 'Custom'
                    app.DropDown_CutType.Enable  = 'on';
                    app.Input_Cut_Value.Enable   = 'on';
                    return;
                case {'E-Plane','H-Plane'}
                    app.DropDown_CutType.Enable  = 'off';
                    app.Input_Cut_Value.Enable   = 'off';
            end
            if isempty(app.R_out); return; end
            % Use the cached boresight axis ('+X','-X',...) so the
            % principal-plane geometry is correct for any orientation.
            [eCut, hCut, eVal, hVal] = APA_v01.ehPlanes(app.R_out, app.BoresightAxis);
            % Clamp into the Cut Value spinner's limits so programmatic
            % writes can never trip an out-of-range alert dialog.
            cutLim = app.Input_Cut_Value.Limits;
            if strcmp(mode,'E-Plane')
                APA_v01.setDropDownSafe(app.DropDown_CutType, eCut);
                app.Input_Cut_Value.Value = max(min(eVal, cutLim(2)), cutLim(1));
            else
                APA_v01.setDropDownSafe(app.DropDown_CutType, hCut);
                app.Input_Cut_Value.Value = max(min(hVal, cutLim(2)), cutLim(1));
            end
        end

        % ---------------------------------------------------------------
        %                          TAB 1 - SINGLE
        % ---------------------------------------------------------------
        function onLoadSingle(app)
            filt = {'*.fz;*.uan;*.ffe;*.ffd;*.ffs;*.out;*.cut;*.csv;*.txt;*.dat', ...
                    'Antenna patterns (*.fz, *.uan, *.ffe, *.ffd, *.ffs, *.out, *.cut, *.csv, *.txt, *.dat)'; ...
                    '*.*','All files (*.*)'};
            [f,p] = uigetfile(filt,'Select an antenna pattern file');
            figure(app.UIFigure);
            if isequal(f,0); return; end
            app.Input_PatternField.Value = fullfile(p,f);
            app.Input_Label.Text = sprintf('Selected: %s', f);

            % If the user picked a generic ASCII table, auto-switch the Format
            % hint to "5" (processed gain) when >=3 numeric columns are
            % detected, and ask which column to use as total gain.
            [~,~,ext] = fileparts(f);
            if any(strcmpi(ext, {'.csv','.txt','.dat'}))
                app.LoadOpts = askProcessedGainColumn(app, fullfile(p,f));
                if isempty(app.LoadOpts); return; end
                app.DropDown_Format.Value = '5';
            else
                app.LoadOpts = struct();
            end

            onProcessSingle(app);                                    % auto-process
        end

        function opts = askProcessedGainColumn(app, file)
            opts = struct();
            try
                M = readmatrix(file,'FileType','text');
            catch
                return;
            end
            nCols = size(M,2);
            if nCols < 3; return; end
            if nCols == 3
                opts.gainCol = 3; return;
            end
            labels = arrayfun(@(k) sprintf('Column %d', k), 3:nCols, ...
                              'UniformOutput', false);
            [sel, ok] = listdlg( ...
                'PromptString', sprintf('File has %d columns.\nSelect the gain (dBi) column:', nCols), ...
                'SelectionMode','single', 'ListString', labels, ...
                'Name','Processed-gain import', 'InitialValue', 1, ...
                'ListSize',[260 180]);
            figure(app.UIFigure);
            if ~ok; opts = []; return; end
            opts.gainCol = sel + 2;
        end

        function onProcessSingle(app)
            file = app.Input_PatternField.Value;
            if isempty(file) || exist(file,'file')~=2
                uialert(app.UIFigure,'Please load an antenna pattern file first.','No file');
                return;
            end
            tAll = tic;
            tStage = tic;
            try
                opts = struct();
                if ~isempty(app.LoadOpts); opts = app.LoadOpts; end
                P = io.loadPattern(file, app.DropDown_Format.Value, opts);
                tLoad = toc(tStage);

                tStage = tic;
                R = proc.processPattern(P, getProcessParams(app));
                tProc = toc(tStage);
            catch ME
                uialert(app.UIFigure, sprintf('%s\n(%s line %d)', ME.message, ME.stack(1).name, ME.stack(1).line), 'Processing failed');
                return;
            end
            app.P_in       = P;
            app.P_in_orig  = P;                      % snapshot for loss-free rotations
            app.R_cum      = eye(3);                 % reset cumulative rotation
            app.R_out      = R;

            % Auto-detect the dominant boresight orientation among the six
            % cardinal directions and snap the Source dropdown to it.
            tStage = tic;
            try
                axisDir = proc.detectBoresight(P);
                app.BoresightAxis = axisDir;        % cached for E/H plane logic
                presetMap = struct( ...
                    'p_X','Source: +X (Fwd)',  'm_X','Source: -X (Aft)', ...
                    'p_Y','Source: +Y (Stbd)', 'm_Y','Source: -Y (Port)', ...
                    'p_Z','Source: +Z (Zenith)','m_Z','Source: -Z (Deck)');
                key = strrep(strrep(axisDir, '+','p_'), '-','m_');
                if isfield(presetMap, key)
                    APA_v01.setDropDownSafe(app.DropDown_Orientation, presetMap.(key));
                    onOrientationPreset(app);
                end
            catch
            end
            tBoresight = toc(tStage);

            % Status labels first - they paint instantly and give the user
            % feedback while the heavier table/plot work runs after.
            app.Input_Label.Text        = sprintf('Loaded %s   (%dx%d  %s)', ...
                P.meta.name, numel(P.theta), numel(P.phi), P.meta.format);
            % Use Unicode (theta, phi, degree) with Interpreter='none' so
            % the labels keep the native Helvetica font of every other
            % uilabel in the app instead of switching to TeX's Computer
            % Modern serif face.
            app.Label_MaxGain.Interpreter = 'none';
            app.Label_MaxGain.Text = sprintf('Peak G_total = %.2f dBi  at  %c = %g%c, %c = %g%c', ...
                R.maxGain_dB, char(952), R.maxGain_dir(1), char(176), char(966), R.maxGain_dir(2), char(176));
            app.Label_MaxInputE.Interpreter = 'none';
            app.Label_MaxInputE.Text = sprintf('|E_%c|_max = %.3g,   |E_%c|_max = %.3g', ...
                char(952), R.maxE_th_Vm, char(966), R.maxE_ph_Vm);
            app.DominantPolLabel.Text = sprintf('Dominant Pol: %s', R.dominantPol);

            % Populate the data tables.  A 65k-row uitable in a uifigure is
            % expensive to render (HTML/JS pipeline).  populateTab1Tables
            % handles the actual write + a "preview only" cap when the
            % pattern is large enough that a full dump would block the UI.
            tStage = tic;
            populateTab1Tables(app, P, R);
            tTables = toc(tStage);

            % Add to library for Tabs 3/4.
            addToLibrary(app, P, R, R.meta.name);

            % Apply the active Cut Mode (E-Plane by default) to the new R.
            % This will (a) set Cut Type / Cut Value to the auto-derived
            % plane when in E/H mode, or (b) leave the user's choices
            % untouched when in 'Custom'.
            applyCutMode(app);
            if strcmp(app.DropDown_CutMode.Value,'Custom')
                app.Input_Cut_Value.Value = R.maxGain_dir(2);
            end

            tStage = tic;
            refreshTab1Plots(app);
            tPlots = toc(tStage);

            tTotal = toc(tAll);
            fprintf('[APA_v01] processSingle: total=%.2fs (load=%.2fs, process=%.2fs, boresight=%.2fs, tables=%.2fs, plots=%.2fs)\n', ...
                tTotal, tLoad, tProc, tBoresight, tTables, tPlots);
        end

        function populateTab1Tables(app, P, R)
            % Populate Tab 1's input/output tables.  For very large grids
            % (>20k rows) the input table is shown as a preview to avoid
            % the multi-second uitable render cost in uifigure.
            try
                Nrows = numel(P.theta) * numel(P.phi);
                [Tg, Pg] = ndgrid(P.theta, P.phi);
                EthMagDB = 20*log10(abs(P.Eth(:)) + eps);
                EphMagDB = 20*log10(abs(P.Eph(:)) + eps);
                EthPh    = angle(P.Eth(:))*180/pi;
                EphPh    = angle(P.Eph(:))*180/pi;
                rawIn  = [Tg(:) Pg(:) EthMagDB EphMagDB EthPh EphPh];
                rawOut = R.table;
                cap = 100000;   % uitable handles 65k in ~0.4s; cap kicks in only for huge grids
                if Nrows > cap
                    app.Table_DataIn.Data  = rawIn(1:cap,  :);
                    app.Table_DataOut.Data = rawOut(1:cap, :);
                    fprintf('[APA_v01] Pattern has %d rows; tables show first %d (data still in P/R for export).\n', ...
                            Nrows, cap);
                else
                    app.Table_DataIn.Data  = rawIn;
                    app.Table_DataOut.Data = rawOut;
                end
            catch ME
                warning('populateTab1Tables:fail','%s', ME.message);
            end
        end

        function refreshTab1Plots(app)
            if isempty(app.R_out); return; end
            R    = app.R_out;
            comp = app.DropDown_Component.Value;
            ctrl = getPlotCtrl(app);

            cutType  = app.DropDown_CutType.Value;
            cutValue = app.Input_Cut_Value.Value;
            showT    = app.E_TotalCheckBox.Value;
            showRH   = app.E_RHCPCheckBox.Value;
            showLH   = app.E_LHCPCheckBox.Value;
            if ~showT && ~showRH && ~showLH; showT = true; end

            % The 3D axes share a generic `ctrl`; bind each to its own
            % sibling uilabel so the Az/El readout lives outside the plot.
            ctrl_sph      = ctrl;  ctrl_sph.AzElLabel = app.Label_AzEl_Spherical;
            ctrl_3d       = ctrl;  ctrl_3d.AzElLabel  = app.Label_AzEl_3D;

            plotJobs = { ...
                'Contour',     @() plt.plotContour(app.Axes_Contour, R, comp, ctrl); ...
                'Circular',    @() plt.plotCircular(app.Axes_Circular, R, comp, ctrl); ...
                'Spherical',   @() plt.plotSpherical(app.Axes_Spherical, R, comp, ctrl_sph); ...
                '3D',          @() plt.plot3D(app.Axes_3D, R, comp, ctrl_3d); ...
                'FilledPolar', @() plt.plotFilledPolar(app.Grid_Filled, R, comp, cutType, ctrl); ...
                'CutPolar',    @() plt.plotCutPolar(app.pax, R, cutType, cutValue, showT, showRH, showLH, ctrl); ...
                'CutRect',     @() plt.plotCutRect(app.Axes_Rect, R, cutType, cutValue, showT, showRH, showLH, ctrl) ...
            };
            timings = zeros(1, size(plotJobs,1));
            for k = 1:size(plotJobs,1)
                t0 = tic;
                try
                    plotJobs{k,2}();
                catch ME
                    uialert(app.UIFigure, ...
                        sprintf('Plot refresh failed in %s: %s\n(%s line %d)', ...
                                plotJobs{k,1}, ME.message, ME.stack(1).name, ME.stack(1).line), ...
                        'Plot', 'Icon','error');
                end
                timings(k) = toc(t0);
            end
            if any(timings > 0.05)
                msg = sprintf('[APA_v01] refreshTab1Plots:');
                for k = 1:size(plotJobs,1)
                    msg = [msg, sprintf('  %s=%.2fs', plotJobs{k,1}, timings(k))]; %#ok<AGROW>
                end
                fprintf('%s  total=%.2fs\n', msg, sum(timings));
            end
            % Keep the HPBW summary label in sync with the current cut
            % whenever the HPBW toggle is active; clear it otherwise.
            try
                if ~isempty(app.R_out) && app.Button2.Value
                    updateHPBWLabel(app);
                else
                    app.Label_HPBW.Text = '';
                end
            catch
            end
        end

        function updateHPBWLabel(app)
            if isempty(app.R_out); app.Label_HPBW.Text = ''; return; end
            R        = app.R_out;
            cutType  = app.DropDown_CutType.Value;
            cutValue = app.Input_Cut_Value.Value;
            [a, gT]  = plt.getCut(R, cutType, cutValue);
            [bw, edges] = proc.hpbw(a, gT);
            [pk, ipk] = max(gT);
            frontAng  = a(ipk);
            backAng   = mod(frontAng + 180, 360);
            backVal   = interp1(a, gT, backAng, 'linear', 'extrap');
            fbr_dB    = pk - backVal;
            if isnan(bw)
                app.Label_HPBW.Text = sprintf( ...
                    ['HPBW:       n/a' newline ...
                     'Peak:       %.2f dBi @ %g' char(176) newline ...
                     'FBR:        %.2f dB'], pk, frontAng, fbr_dB);
            else
                app.Label_HPBW.Text = sprintf( ...
                    ['HPBW:       %.2f' char(176) newline ...
                     'Edges:      %.1f' char(176) ' .. %.1f' char(176) newline ...
                     'Peak:       %.2f dBi @ %g' char(176) newline ...
                     'FBR:        %.2f dB'], ...
                    bw, edges(1), edges(2), pk, frontAng, fbr_dB);
            end
        end

        function onHPBW(app)
            % Toggling the HPBW state button simply refreshes the plots
            % (ctrl.ShowHPBW gates the overlay).  The label is rebuilt in
            % refreshTab1Plots via updateHPBWLabel when the button is on.
            refreshTab1Plots(app);
        end

        function onOrientationPreset(app)
            % Snap the Source theta/phi spinners to match the currently
            % selected preset, so the rotation inputs stay informative.
            orient = app.DropDown_Orientation.Value;
            switch orient
                case 'Source: +X (Fwd)',      th = 90;  ph = 0;
                case 'Source: -X (Aft)',      th = 90;  ph = 180;
                case 'Source: +Y (Stbd)',     th = 90;  ph = 90;
                case 'Source: -Y (Port)',     th = 90;  ph = 270;
                case 'Source: +Z (Zenith)',   th = 0;   ph = 0;
                case 'Source: -Z (Deck)',     th = 180; ph = 0;
                otherwise
                    return;                                                % 'Custom' / header - keep user values
            end
            APA_v01.setDropDownSafe(app.SourceDropDown,   sprintf('%g', th));
            APA_v01.setDropDownSafe(app.SourceDropDown_2, sprintf('%g', ph));
        end

        function onRotate(app)
            if isempty(app.P_in) || isempty(app.P_in_orig)
                uialert(app.UIFigure,'Load and process a pattern first.','Rotate'); return;
            end
            try
                orient = app.DropDown_Orientation.Value;
                sTh = APA_v01.parseSpinnerOrZero(app.SourceDropDown.Value);
                sPh = APA_v01.parseSpinnerOrZero(app.SourceDropDown_2.Value);
                dTh = APA_v01.parseSpinnerOrZero(app.DestinationDropDown.Value);
                dPh = APA_v01.parseSpinnerOrZero(app.DestinationDropDown_2.Value);
                % Loss-free rotation strategy:
                %   - P_in_orig holds the untouched pattern.
                %   - R_cum is the cumulative rotation currently applied.
                %   - Each click composes the step rotation into R_cum and
                %     we resample ONCE from the original.  If the user ever
                %     brings the composite back to identity, the displayed
                %     pattern is bit-exact with the input data.
                Rstep = proc.vecToVecRotation(proc.sphToVec([sTh sPh]), proc.sphToVec([dTh dPh]));
                app.R_cum = Rstep * app.R_cum;
                % Snap to true identity when we are within numerical noise -
                % this guarantees the original pattern is displayed unchanged
                % after a round-trip rotation.
                if norm(app.R_cum - eye(3), 'fro') < 1e-10
                    app.R_cum = eye(3);
                end
                P = proc.rotatePattern(app.P_in_orig, 'matrix', app.R_cum);
                app.P_in  = P;
                app.R_out = proc.processPattern(P, getProcessParams(app));
                app.RotationLabel.Text = sprintf('Rotation: applied (%s)', orient);

                % After a successful rotation the pattern is now oriented
                % at (dTh, dPh); make the Source fields reflect the new
                % reference orientation.
                APA_v01.setDropDownSafe(app.SourceDropDown,   sprintf('%g', dTh));
                APA_v01.setDropDownSafe(app.SourceDropDown_2, sprintf('%g', dPh));

                % Reflect the rotation in the input & output tables.
                [Tg, Pg] = ndgrid(P.theta, P.phi);
                app.Table_DataIn.Data = [Tg(:) Pg(:) ...
                    20*log10(abs(P.Eth(:))+eps) 20*log10(abs(P.Eph(:))+eps) ...
                    angle(P.Eth(:))*180/pi      angle(P.Eph(:))*180/pi];
                app.Table_DataOut.Data = app.R_out.table;

                % Refresh peak-gain label (it may shift after rotation).
                app.Label_MaxGain.Interpreter = 'none';
                app.Label_MaxGain.Text = sprintf('Peak G_total = %.2f dBi  at  %c = %g%c, %c = %g%c', ...
                    app.R_out.maxGain_dB, char(952), app.R_out.maxGain_dir(1), char(176), ...
                    char(966), app.R_out.maxGain_dir(2), char(176));

                refreshTab1Plots(app);
            catch ME
                uialert(app.UIFigure, sprintf('%s\n(%s line %d)', ME.message, ME.stack(1).name, ME.stack(1).line), 'Rotation failed');
            end
        end

        function onExportInput(app)
            % Export the raw/input pattern with format interchangeability.
            % The exported pattern already reflects any applied rotation
            % because we mutate app.P_in on rotate.
            if isempty(app.P_in)
                if isempty(app.Table_DataIn.Data); return; end
                % Fallback: table dump only, no original pattern struct.
                [f,p] = uiputfile({'*.csv';'*.xlsx';'*.mat'}, 'Export Input', 'pattern_input.csv');
                figure(app.UIFigure); if isequal(f,0); return; end
                T = array2table(app.Table_DataIn.Data, 'VariableNames', app.Table_DataIn.ColumnName);
                writetable(T, fullfile(p,f));
                return;
            end
            filt = { ...
                '*.fz',  'XGTD far-zone (*.fz)'; ...
                '*.uan', 'XGTD universal antenna (*.uan)'; ...
                '*.ffe', 'FEKO far-field (*.ffe)'; ...
                '*.ffd', 'HFSS far-field (*.ffd)'; ...
                '*.ffs', 'CST far-field source (*.ffs)'; ...
                '*.csv', 'CSV (theta, phi, |Eth|dB, |Eph|dB, phases) (*.csv)'; ...
                '*.mat', 'MATLAB struct (*.mat)'};
            base = app.P_in.meta.name;
            [f,p] = uiputfile(filt, 'Export Raw Pattern (any supported format)', [base,'.fz']);
            figure(app.UIFigure); if isequal(f,0); return; end
            outFile = fullfile(p,f);
            try
                [~,~,ext] = fileparts(outFile);
                if strcmpi(ext,'.mat')
                    P = app.P_in;                                              %#ok<NASGU>
                    save(outFile,'P');
                else
                    io.writePattern(app.P_in, outFile);
                end
                uialert(app.UIFigure, sprintf('Exported to %s', outFile), ...
                        'Export', 'Icon','success');
            catch ME
                uialert(app.UIFigure, ME.message, 'Export failed');
            end
        end

        function onExportOutput(app)
            if isempty(app.Table_DataOut.Data); return; end
            [f,p] = uiputfile({'*.csv';'*.xlsx';'*.mat'}, 'Export Output', 'pattern_output.csv');
            figure(app.UIFigure); if isequal(f,0); return; end
            T = array2table(app.Table_DataOut.Data, 'VariableNames', app.Table_DataOut.ColumnName);
            writetable(T, fullfile(p,f));
        end

        function onExportCut(app)
            if isempty(app.R_out); return; end
            R = app.R_out;
            cutType  = app.DropDown_CutType.Value;
            cutValue = app.Input_Cut_Value.Value;
            [a, gT, gR, gL] = plt.getCut(R, cutType, cutValue);
            T = table(a, gT, gR, gL, 'VariableNames', {'Angle_deg','G_Total_dB','G_RHCP_dBic','G_LHCP_dBic'});
            [f,p] = uiputfile({'*.csv';'*.xlsx'}, 'Export Cut', sprintf('cut_%s_%g.csv', strrep(cutType,' ','_'), cutValue));
            figure(app.UIFigure); if isequal(f,0); return; end
            writetable(T, fullfile(p,f));
        end

        function onComputeCoverageFromTab1(app)
            if isempty(app.R_out)
                uialert(app.UIFigure,'Process a pattern first.','Coverage'); return;
            end
            app.TabGroup.SelectedTab = app.Tab3_Coverage;
            refreshLibraryTrees(app);
        end

        % ---------------------------------------------------------------
        %                          TAB 2 - BATCH
        % ---------------------------------------------------------------
        function onLoadBatch(app)
            d = uigetdir('','Select root folder containing antenna pattern files');
            figure(app.UIFigure);
            if isequal(d,0); return; end
            app.RootFolder = d;
            app.Input_PatternField_Batch.Value = d;
            populateBatchTree(app, d);
        end

        function populateBatchTree(app, root)
            delete(allchild(app.Tree2));
            exts = {'*.fz','*.uan','*.ffe','*.ffd','*.ffs','*.out','*.cut'};
            files = [];
            for k = 1:numel(exts)
                files = [files; dir(fullfile(root,'**',exts{k}))]; %#ok<AGROW>
            end
            if isempty(files)
                rootNode = uitreenode(app.Tree2, 'Text', '(no patterns found)');
                rootNode.NodeData = '';
                return;
            end
            rootNode = uitreenode(app.Tree2, 'Text', root);
            rootNode.NodeData = root;

            gain3dOnly = false;
            try; gain3dOnly = logical(app.CB_BatchGain3dOnly.Value); catch; end

            preChecked = {};
            folders = unique({files.folder});
            for i = 1:numel(folders)
                rel = strrep(folders{i}, root, '.');
                folderNode = uitreenode(rootNode, 'Text', rel);
                folderNode.NodeData = folders{i};
                inFolder = strcmp({files.folder}, folders{i});
                for j = find(inFolder)
                    fname = files(j).name;
                    isGain3d = ~isempty(regexpi(fname, 'gain3d', 'once'));
                    disp = fname;
                    if isGain3d
                        disp = ['[gain3d] ' fname]; %#ok<AGROW>
                    end
                    leaf = uitreenode(folderNode, 'Text', disp);
                    leaf.NodeData = fullfile(files(j).folder, files(j).name);
                    % Pre-check rules: when the gain3d-only toggle is on we
                    % only check *.fz files whose name contains "gain3d"
                    % (XGTD convention for 3D far-field gains).  Otherwise
                    % every *.fz file is pre-checked so the user keeps the
                    % previous "check-everything-by-default" behaviour.
                    [~,~,ext] = fileparts(fname);
                    if strcmpi(ext,'.fz')
                        if ~gain3dOnly || isGain3d
                            preChecked{end+1,1} = leaf; %#ok<AGROW>
                        end
                    end
                end
            end
            expand(app.Tree2,'all');
            if ~isempty(preChecked)
                try; app.Tree2.CheckedNodes = vertcat(preChecked{:}); catch; end
            end
        end

        function onProcessBatch(app)
            chk = app.Tree2.CheckedNodes;
            paths = {};
            for k = 1:numel(chk)
                if ischar(chk(k).NodeData) && exist(chk(k).NodeData,'file')==2
                    paths{end+1,1} = chk(k).NodeData; %#ok<AGROW>
                end
            end
            paths = unique(paths);
            if isempty(paths)
                uialert(app.UIFigure,'Check at least one pattern file in the tree.','Batch'); return;
            end

            % Decide where to put auto-exported results.  Anchor on the root
            % folder the user selected; fall back to the common parent of
            % the checked files if the root field is missing.
            rootDir = app.RootFolder;
            if isempty(rootDir) || ~isfolder(rootDir)
                rootDir = fileparts(paths{1});
            end
            resultsDir = fullfile(rootDir, 'results');
            try
                if ~isfolder(resultsDir); mkdir(resultsDir); end
            catch
            end

            outFmt   = '.csv';
            try; outFmt = app.DropDown_BatchExportFmt.Value; catch; end
            savePlots = false;
            try; savePlots = logical(app.CB_BatchSavePlots.Value); catch; end

            params = getProcessParams(app, true);
            app.Batch = cell(numel(paths),1);
            okCount = 0;
            d = uiprogressdlg(app.UIFigure,'Title','Batch processing','Indeterminate','off');
            for k = 1:numel(paths)
                d.Value = (k-1)/numel(paths);
                d.Message = sprintf('(%d/%d) %s', k, numel(paths), paths{k});
                try
                    P = io.loadPattern(paths{k}, app.DropDown_Format_2.Value);
                    R = proc.processPattern(P, params);
                    app.Batch{k} = struct('file', paths{k}, 'P', P, 'R', R, 'ok', true, 'err','', 'outDir', resultsDir);
                    okCount = okCount + 1;
                    addToLibrary(app, P, R, P.meta.name);
                    % Auto-export per-pattern into results/<name>/.
                    try
                        APA_v01.exportBatchOne(resultsDir, P, R, outFmt, savePlots);
                    catch MEw
                        warning('Auto-export failed for %s: %s', P.meta.name, MEw.message);
                    end
                catch ME
                    app.Batch{k} = struct('file', paths{k}, 'P',[], 'R',[], 'ok',false, 'err', ME.message, 'outDir',resultsDir);
                    uialert(app.UIFigure, sprintf('%s\n(%s line %d)', ME.message, ME.stack(1).name, ME.stack(1).line), 'Batch Processing Error');
                end
            end
            close(d);
            app.Input_Label_2.Text = sprintf('Processed %d / %d files OK - results -> %s', ...
                okCount, numel(paths), resultsDir);
            populateBatchTreeLeaves(app);
        end

        function populateBatchTreeLeaves(app)
            % After a successful batch, mark processed leaves with a (ok)
            % suffix so the user can see which ones are available for
            % inspection.  Non-destructive; keeps NodeData/check state.
            if isempty(app.Batch); return; end
            tree = app.Tree2;
            stack = tree.Children(:);
            while ~isempty(stack)
                n = stack(1); stack(1) = [];
                if ~isempty(n.Children); stack = [stack; n.Children(:)]; end %#ok<AGROW>
                if ischar(n.NodeData)
                    for k = 1:numel(app.Batch)
                        e = app.Batch{k};
                        if ~isempty(e) && isfield(e,'file') && strcmp(e.file, n.NodeData)
                            tag = '(fail)';
                            if e.ok; tag = '(ok)'; end
                            if ~contains(n.Text, tag)
                                n.Text = [n.Text '  ' tag];
                            end
                        end
                    end
                end
            end
        end

        function onBatchTreeSelect(app)
            % Show metadata + quick inspection plot for the selected node.
            sel = app.Tree2.SelectedNodes;
            if isempty(sel) || ~ischar(sel(1).NodeData); return; end
            filePath = sel(1).NodeData;
            e = [];
            for k = 1:numel(app.Batch)
                if ~isempty(app.Batch{k}) && isfield(app.Batch{k},'file') && ...
                        strcmp(app.Batch{k}.file, filePath)
                    e = app.Batch{k}; break;
                end
            end
            if isempty(e)
                app.Label_BatchInfo.Text = sprintf('%s\n(not processed yet)', filePath);
                cla(app.Axes_BatchInspect,'reset');
                return;
            end
            if ~e.ok
                [~, baseName] = fileparts(filePath);
                app.Label_BatchInfo.Text = sprintf('\\bf%s\\rm\\newlineFAILED: %s', ...
                    strrep(baseName,'_','\_'), e.err);
                cla(app.Axes_BatchInspect,'reset');
                return;
            end
            P = e.P; R = e.R;
            app.Label_BatchInfo.Text = sprintf(['\\bf%s\\rm\\newline' ...
                'Grid: %dx%d   Format: %s\\newline' ...
                'Peak G_{total}: %.2f dBi at (\\theta=%g\\circ, \\phi=%g\\circ)\\newline' ...
                'Dominant Pol: %s'], ...
                strrep(P.meta.name,'_','\_'), numel(P.theta), numel(P.phi), ...
                P.meta.format, R.maxGain_dB, R.maxGain_dir(1), R.maxGain_dir(2), ...
                R.dominantPol);
            onBatchInspectRefresh(app);
        end

        function onBatchInspectRefresh(app)
            sel = app.Tree2.SelectedNodes;
            if isempty(sel) || ~ischar(sel(1).NodeData); return; end
            filePath = sel(1).NodeData;
            e = [];
            for k = 1:numel(app.Batch)
                if ~isempty(app.Batch{k}) && isfield(app.Batch{k},'file') && ...
                        strcmp(app.Batch{k}.file, filePath) && app.Batch{k}.ok
                    e = app.Batch{k}; break;
                end
            end
            if isempty(e); cla(app.Axes_BatchInspect,'reset'); return; end
            R    = e.R;
            comp = app.DropDown_BatchComp.Value;
            ctrl = getPlotCtrl(app);
            ctrl.viewChangedCb = [];
            ax   = app.Axes_BatchInspect;
            try
                switch app.DropDown_BatchView.Value
                    case 'Contour',     plt.plotContour(ax, R, comp, ctrl);
                    case 'Circular',    plt.plotCircular(ax, R, comp, ctrl);
                    case 'Spherical',   plt.plotSpherical(ax, R, comp, ctrl);
                    case '3D',          plt.plot3D(ax, R, comp, ctrl);
                    case 'Filled Polar'
                        % Needs a grid parent; fall back to contour here.
                        plt.plotContour(ax, R, comp, ctrl);
                    case 'Rect Cut'
                        plt.plotCutRect(ax, R, 'Phi Cut', R.maxGain_dir(1), true, false, false, ctrl);
                    case 'Polar Cut'
                        plt.plotCutRect(ax, R, 'Theta Cut', R.maxGain_dir(2), true, false, false, ctrl);
                end
            catch ME
                cla(ax,'reset');
                text(ax, 0.5, 0.5, sprintf('Plot failed: %s', ME.message), ...
                    'HorizontalAlignment','center');
            end
        end

        function onExportBatchInput(app)
            if isempty(app.Batch); return; end
            [f,p] = uiputfile({'*.xlsx'},'Export Batch Inputs','batch_inputs.xlsx');
            figure(app.UIFigure); if isequal(f,0); return; end
            out = fullfile(p,f);
            d = uiprogressdlg(app.UIFigure,'Title','Writing','Indeterminate','off');
            for k = 1:numel(app.Batch)
                e = app.Batch{k};
                if ~e.ok || isempty(e.P); continue; end
                d.Value = (k-1)/numel(app.Batch);
                P = e.P;
                [Tg, Pg] = ndgrid(P.theta, P.phi);
                T = table(Tg(:), Pg(:), 20*log10(abs(P.Eth(:))+eps), 20*log10(abs(P.Eph(:))+eps), ...
                          angle(P.Eth(:))*180/pi, angle(P.Eph(:))*180/pi, ...
                          'VariableNames', {'Theta','Phi','Eth_dB','Eph_dB','Eth_phase','Eph_phase'});
                sh = APA_v01.sanitizeSheet(P.meta.name, k);
                writetable(T, out, 'Sheet', sh);
            end
            close(d);
        end

        function onExportBatchOutput(app)
            if isempty(app.Batch); return; end
            [f,p] = uiputfile({'*.xlsx'},'Export Batch Outputs','batch_outputs.xlsx');
            figure(app.UIFigure); if isequal(f,0); return; end
            out = fullfile(p,f);
            colN = app.Table_DataOut.ColumnName;
            d = uiprogressdlg(app.UIFigure,'Title','Writing','Indeterminate','off');
            summary = {};
            for k = 1:numel(app.Batch)
                e = app.Batch{k};
                if ~e.ok || isempty(e.R); continue; end
                d.Value = (k-1)/numel(app.Batch);
                T = array2table(e.R.table,'VariableNames',colN);
                sh = APA_v01.sanitizeSheet(e.P.meta.name, k);
                writetable(T, out, 'Sheet', sh);
                summary(end+1,:) = {e.P.meta.name, e.R.maxGain_dB, e.R.maxGain_dir(1), ...
                                    e.R.maxGain_dir(2), e.R.dominantPol}; %#ok<AGROW>
            end
            if ~isempty(summary)
                Ts = cell2table(summary,'VariableNames',{'File','PeakGain_dB','PeakTheta','PeakPhi','DominantPol'});
                writetable(Ts, out, 'Sheet','Summary');
            end
            close(d);
        end

        % ---------------------------------------------------------------
        %                       TAB 3 - COVERAGE
        % ---------------------------------------------------------------
        function updateConicalEnable(app)
            if app.Button_Conical.Value
                state = 'on';
            else
                state = 'off';
            end
            app.Cone0Label.Enable    = state;
            app.ConeLabel.Enable     = state;
            app.CongAngleLabel.Enable= state;
            app.Spinner_coneTH.Enable= state;
            app.Spinner_conePH.Enable= state;
            app.Spinner_coneAng.Enable=state;
        end

        function onLoadCoverageFile(app)
            filt = {'*.fz;*.uan;*.ffe;*.ffd;*.ffs;*.out;*.cut;*.csv;*.txt;*.dat', ...
                    'Antenna patterns or precomputed coverage tables'; ...
                    '*.*','All files'};
            [f,p] = uigetfile(filt,'Select pattern or coverage file','MultiSelect','on');
            figure(app.UIFigure);
            if isequal(f,0); return; end
            if ischar(f); f = {f}; end
            for k = 1:numel(f)
                file = fullfile(p,f{k});
                [~,nm,ext] = fileparts(file);
                try
                    if any(strcmpi(ext, {'.csv','.txt','.dat'})) && ...
                            APA_v01.looksLikeCoverageFile(file)
                        importCoverageFile(app, file);
                    else
                        P = io.loadPattern(file, '1');
                        R = proc.processPattern(P, getProcessParams(app));
                        addToLibrary(app, P, R, P.meta.name);
                    end
                catch ME
                    uialert(app.UIFigure, sprintf('%s\n(%s line %d)', ...
                        ME.message, ME.stack(1).name, ME.stack(1).line), ...
                        sprintf('Load failed: %s', nm));
                end
            end
            app.Input_PatternField_Coverage.Value = sprintf('%d pattern(s), %d coverage run(s)', ...
                numel(app.Lib), numel(app.CovRuns));
            refreshLibraryTrees(app);
            refreshCoverageDisplay(app);
        end

        function importCoverageFile(app, file)
            T = readtable(file,'FileType','text');
            if width(T) < 2
                error('importCoverageFile:cols','Need >=2 columns (threshold + coverage).');
            end
            thr = T{:,1};
            vars = T.Properties.VariableNames;
            [~, base] = fileparts(file);
            for c = 2:width(T)
                run = struct('patIdx',NaN, 'mode','imported', ...
                             'params',struct(), ...
                             'thr', thr(:), 'cov', T{:,c}, ...
                             'name', sprintf('%s : %s', base, vars{c}), ...
                             'visible', true);
                app.CovRuns{end+1} = run;
            end
        end

        function onComputeCoverage(app)
            chk = app.Tree.CheckedNodes;
            idx = [];
            for k = 1:numel(chk)
                nd = chk(k).NodeData;
                if isstruct(nd) && strcmp(nd.type,'pattern')
                    idx(end+1,1) = nd.libIdx; %#ok<AGROW>
                end
            end
            idx = unique(idx);
            if isempty(idx)
                uialert(app.UIFigure,'Check at least one pattern in the tree.','Coverage'); return;
            end

            params.thrMin  = app.Spinner_threshMin.Value;
            params.thrMax  = app.Spinner_threshMax.Value;
            params.thrStep = app.Spinner_threshStep.Value;
            if params.thrMax <= params.thrMin
                uialert(app.UIFigure,'Threshold Max must be > Min.','Coverage'); return;
            end

            if app.Button_Spherical.Value
                mode = 'spherical';
                tag  = 'Sph';
            else
                mode = 'conical';
                params.coneTheta_deg = app.Spinner_coneTH.Value;
                params.conePhi_deg   = app.Spinner_conePH.Value;
                params.coneAlpha_deg = app.Spinner_coneAng.Value;
                [params.coneTheta_deg, params.conePhi_deg] = ...
                    APA_v01.orientationToAngles(app.DropDown_covOrientation.Value, ...
                        params.coneTheta_deg, params.conePhi_deg);
                tag = sprintf('Cone(%g,%g,a=%g)', params.coneTheta_deg, ...
                              params.conePhi_deg, params.coneAlpha_deg);
            end

            for j = 1:numel(idx)
                R = app.Lib{idx(j)}.R;
                [thr, c] = proc.computeCoverage(R, mode, params);
                run = struct('patIdx', idx(j), 'mode', mode, ...
                             'params', params, ...
                             'thr', thr(:), 'cov', c(:), ...
                             'name', sprintf('%s : %s', app.LibNames{idx(j)}, tag), ...
                             'visible', true);
                app.CovRuns{end+1} = run;
            end

            refreshLibraryTrees(app);
            refreshCoverageDisplay(app);
        end

        function refreshCoverageDisplay(app)
            % Collect all checked coverage runs from the tree and plot /
            % tabulate only those.  Also reflect per-node visibility flags
            % back into app.CovRuns so export uses the current selection.
            chk = app.Tree.CheckedNodes;
            checkedRuns = false(size(app.CovRuns));
            for k = 1:numel(chk)
                nd = chk(k).NodeData;
                if isstruct(nd) && strcmp(nd.type,'run')
                    checkedRuns(nd.runIdx) = true;
                end
            end
            for k = 1:numel(app.CovRuns)
                app.CovRuns{k}.visible = checkedRuns(k);
            end

            visIdx = find(checkedRuns);
            if isempty(visIdx)
                cla(app.UIAxes,'reset');
                title(app.UIAxes,'Coverage vs threshold (nothing selected)');
                app.UITable.Data       = {};
                app.UITable.ColumnName = {'Threshold_dB'};
                app.CovThr = []; app.CovData = []; app.CovNames = {};
                return;
            end

            thrAll  = cellfun(@(r) r.thr, app.CovRuns(visIdx), 'UniformOutput', false);
            names   = cellfun(@(r) r.name, app.CovRuns(visIdx), 'UniformOutput', false);
            covAll  = cellfun(@(r) r.cov,  app.CovRuns(visIdx), 'UniformOutput', false);

            % Interpolate to a common threshold grid (union of all thrs).
            thrC = unique(vertcat(thrAll{:}));
            covC = nan(numel(thrC), numel(visIdx));
            for k = 1:numel(visIdx)
                t = thrAll{k}; v = covAll{k};
                [t, ia] = unique(t); v = v(ia);
                covC(:,k) = interp1(t, v, thrC, 'linear', NaN);
            end

            app.CovThr   = thrC;
            app.CovData  = covC;
            app.CovNames = names;

            plt.plotCoverage(app.UIAxes, thrC, covC, names, getCoveragePlotCtrl(app));

            app.UITable.ColumnName = ['Threshold_dB', names];
            app.UITable.Data       = [thrC covC];
        end

        function ctrl = getCoveragePlotCtrl(app)
            ctrl = struct('gridOn', true, 'legendOn', true, 'lineWidth', 1.6);
            try, ctrl.gridOn   = logical(app.CB_covGrid.Value);   catch; end
            try, ctrl.legendOn = logical(app.CB_covLegend.Value); catch; end
            try, ctrl.lineWidth = app.Spinner_covLineWidth.Value; catch; end
        end

        function onClearCoverageSel(app)
            chk = app.Tree.CheckedNodes;
            patternsToDelete = [];
            runsToDelete     = [];
            for k = 1:numel(chk)
                nd = chk(k).NodeData;
                if ~isstruct(nd); continue; end
                switch nd.type
                    case 'pattern'; patternsToDelete(end+1) = nd.libIdx; %#ok<AGROW>
                    case 'run';     runsToDelete(end+1)     = nd.runIdx; %#ok<AGROW>
                end
            end
            if isempty(patternsToDelete) && isempty(runsToDelete)
                uialert(app.UIFigure, 'Check at least one pattern or coverage run first.', 'Clear'); return;
            end
            % Remove runs that belong to the deleted patterns.
            if ~isempty(patternsToDelete)
                for k = 1:numel(app.CovRuns)
                    if any(app.CovRuns{k}.patIdx == patternsToDelete)
                        runsToDelete(end+1) = k; %#ok<AGROW>
                    end
                end
            end
            runsToDelete = unique(runsToDelete);
            app.CovRuns(runsToDelete) = [];
            % Re-index remaining runs' patIdx after pattern deletions.
            if ~isempty(patternsToDelete)
                keep = true(1, numel(app.Lib));
                keep(patternsToDelete) = false;
                app.Lib      = app.Lib(keep);
                app.LibNames = app.LibNames(keep);
                newIndex = cumsum(keep);
                for k = 1:numel(app.CovRuns)
                    old = app.CovRuns{k}.patIdx;
                    if ~isnan(old) && old >=1 && old <= numel(keep) && keep(old)
                        app.CovRuns{k}.patIdx = newIndex(old);
                    elseif ~isnan(old)
                        app.CovRuns{k}.patIdx = NaN;
                    end
                end
            end
            refreshLibraryTrees(app);
            refreshCoverageDisplay(app);
        end

        function onTreeDoubleClick(app, tree, event)
            nd = event.InteractionInformation.Node;
            if isempty(nd) || ~isstruct(nd.NodeData); return; end
            meta = nd.NodeData;
            switch meta.type
                case 'pattern'
                    old = app.LibNames{meta.libIdx};
                    resp = inputdlg({'Pattern name:'},'Rename pattern',[1 50],{old});
                    figure(app.UIFigure);
                    if isempty(resp) || isempty(strtrim(resp{1})); return; end
                    newName = strtrim(resp{1});
                    app.LibNames{meta.libIdx} = newName;
                    % Update any coverage run names prefixed with the old name.
                    for k = 1:numel(app.CovRuns)
                        rn = app.CovRuns{k};
                        if startsWith(rn.name, [old ' : '])
                            app.CovRuns{k}.name = [newName rn.name(numel(old)+1:end)];
                        end
                    end
                case 'run'
                    old = app.CovRuns{meta.runIdx}.name;
                    resp = inputdlg({'Coverage run name:'},'Rename run',[1 60],{old});
                    figure(app.UIFigure);
                    if isempty(resp) || isempty(strtrim(resp{1})); return; end
                    app.CovRuns{meta.runIdx}.name = strtrim(resp{1});
                otherwise
                    return;
            end
            refreshLibraryTrees(app);
            refreshCoverageDisplay(app);
        end

        function onExportCoverage(app)
            if isempty(app.CovData); return; end
            [f,p] = uiputfile({'*.csv';'*.xlsx'},'Export Coverage','coverage.csv');
            figure(app.UIFigure); if isequal(f,0); return; end
            T = array2table([app.CovThr app.CovData], ...
                'VariableNames', matlab.lang.makeValidName(['Threshold_dB', app.CovNames]));
            writetable(T, fullfile(p,f));
            % Also save figure as PNG.
            [~, base] = fileparts(f);
            try
                exportgraphics(app.UIAxes, fullfile(p, [base '.png']), 'Resolution', 200);
            catch ME
                uialert(app.UIFigure, sprintf('%s\n(%s line %d)', ...
                    ME.message, ME.stack(1).name, ME.stack(1).line), 'Export Error');
            end
        end

        % ---------------------------------------------------------------
        %                       TAB 4 - COMBINE
        % ---------------------------------------------------------------
        function onRefreshLibrary(app)
            % Lets the user add more files into the library before combining.
            filt = {'*.fz;*.uan;*.ffe;*.ffd;*.ffs;*.out;*.cut','Antenna patterns'; '*.*','All files'};
            [f,p] = uigetfile(filt,'Select pattern(s) to add','MultiSelect','on');
            figure(app.UIFigure);
            if isequal(f,0); refreshLibraryTrees(app); return; end
            if ischar(f); f = {f}; end
            for k = 1:numel(f)
                try
                    P = io.loadPattern(fullfile(p,f{k}), '1');
                    R = proc.processPattern(P, getProcessParams(app));
                    addToLibrary(app, P, R, P.meta.name);
                catch ME
                    uialert(app.UIFigure, sprintf('%s\n(%s line %d)', ME.message, ME.stack(1).name, ME.stack(1).line), 'Load Error'); % uialert(app.UIFigure, ME.message,'Load');
                end
            end
            refreshLibraryTrees(app);
        end

        function onCombine(app)
            % Resolve checked patterns from the tree.
            [idx, names] = getCheckedPatternIndices(app);
            if isempty(idx)
                uialert(app.UIFigure,'Check at least one pattern.','Combine'); return;
            end

            method = activeCombineMethod(app);

            patterns = cell(numel(idx),1);
            for j = 1:numel(idx); patterns{j} = app.Lib{idx(j)}.P; end
            opts = struct('weights', ones(numel(idx),1));

            if strcmp(method,'masked')
                masks = readMasksFromTable(app, numel(idx));
                if isempty(masks); return; end
                opts.masks = masks;
            end

            try
                Q  = proc.combinePatterns(patterns, method, opts);
                Rq = proc.processPattern(Q, getProcessParams(app));
                tag = strjoin(names, '+');
                if numel(tag) > 40; tag = sprintf('%dpat', numel(idx)); end
                addToLibrary(app, Q, Rq, sprintf('combined_%s_%s', method, tag));
                app.Combined = struct('P', Q, 'R', Rq);
                refreshLibraryTrees(app);
                uialert(app.UIFigure, sprintf('Combined %d patterns with method "%s". Peak = %.2f dB.', ...
                    numel(idx), method, Rq.maxGain_dB), 'Combine OK', 'Icon','success');
            catch ME
                uialert(app.UIFigure, sprintf('%s\n(%s line %d)', ME.message, ME.stack(1).name, ME.stack(1).line), 'Combine failed');
            end
        end

        function [idx, names] = getCheckedPatternIndices(app)
            chk = app.Tree2_2.CheckedNodes;
            idx   = zeros(0,1);
            names = {};
            seen  = false(1, numel(app.Lib));
            for k = 1:numel(chk)
                d = chk(k).NodeData;
                if isnumeric(d) && ~isempty(d) && d>=1 && d<=numel(app.Lib) && ~seen(d)
                    idx(end+1,1) = d;          %#ok<AGROW>
                    names{end+1} = app.Lib{d}.name; %#ok<AGROW>
                    seen(d) = true;
                end
            end
        end

        function method = activeCombineMethod(app)
            sel = app.RadioGroup_CombineMethod.SelectedObject;
            if isempty(sel); method = 'coherent'; return; end
            switch sel
                case app.Radio_Coherent,   method = 'coherent';
                case app.Radio_Incoherent, method = 'incoherent';
                case app.Radio_Envelope,   method = 'envelope';
                case app.Radio_Masked,     method = 'masked';
                otherwise,                 method = 'coherent';
            end
        end

        function onCombineMethodChanged(app)
            % Show / hide the masking panel when the user toggles the
            % radio group.  Also (re)build the mask table from the
            % currently-checked patterns so it's ready to use.
            isMasked = (app.RadioGroup_CombineMethod.SelectedObject == app.Radio_Masked);
            if isMasked
                app.Panel_Masking.Visible = 'on';
                rebuildMaskTable(app);
            else
                app.Panel_Masking.Visible = 'off';
            end
        end

        function onMaskingPatternsChanged(app)
            % The set of checked patterns changed - if section-based mode
            % is active, refresh the mask table to one row per pattern.
            if app.RadioGroup_CombineMethod.SelectedObject == app.Radio_Masked
                rebuildMaskTable(app);
            end
        end

        function rebuildMaskTable(app)
            % Populate Table_Masks with one row per CHECKED pattern.
            % Defaults: full sphere [0 180 0 360] for all rows; the LAST
            % row is the auto-filled "leftover" (read-only display only).
            [idx, names] = getCheckedPatternIndices(app);
            n = numel(idx);
            if n == 0
                app.Table_Masks.Data = {};
                return;
            end
            data = cell(n, 5);
            for k = 1:n
                data{k,1} = names{k};
                data{k,2} = 0;
                data{k,3} = 180;
                data{k,4} = 0;
                data{k,5} = 360;
            end
            % Sensible starting partition for the first n-1 rows; the last
            % row is updated by applyLeftoverRow (phi, theta, or 2D).
            if n > 1
                mode = getMaskLeftoverMode(app);
                switch mode
                    case 'phi'
                        phiEdges = linspace(0, 360, n+1);
                        for k = 1:n-1
                            data{k,4} = round(phiEdges(k));
                            data{k,5} = round(phiEdges(k+1));
                        end
                    case 'theta'
                        thEdges = linspace(0, 180, n+1);
                        for k = 1:n-1
                            data{k,2} = round(thEdges(k));
                            data{k,3} = round(thEdges(k+1));
                        end
                    otherwise  % 'both'
                        phiEdges = linspace(0, 360, n+1);
                        for k = 1:n-1
                            data{k,4} = round(phiEdges(k));
                            data{k,5} = round(phiEdges(k+1));
                        end
                end
            end
            app.Table_Masks.Data = data;
            applyLeftoverRow(app);
        end

        function onMaskTableEdited(app)
            % Recompute the last row from the earlier rows (mode from
            % DropDown_MaskLeftoverMode).
            applyLeftoverRow(app);
        end

        function onMaskLeftoverModeChanged(app)
            % Re-seed the table so the default partition matches the
            % selected dimension (phi bands, theta bands, or both / 2D).
            if app.RadioGroup_CombineMethod.SelectedObject == app.Radio_Masked
                rebuildMaskTable(app);
            end
        end

        function mode = getMaskLeftoverMode(app)
            try
                v = app.DropDown_MaskLeftoverMode.Value;
            catch
                v = 'phi';
            end
            if isstring(v) || ischar(v)
                mode = char(v);
            else
                mode = 'phi';
            end
            if ~any(strcmp(mode, {'phi','theta','both'}))
                mode = 'phi';
            end
        end

        function applyLeftoverRow(app)
            d = app.Table_Masks.Data;
            if isempty(d) || size(d,1) < 2; return; end
            n = size(d,1);
            mode = getMaskLeftoverMode(app);
            rects = zeros(n-1, 4);
            for k = 1:n-1
                rects(k,:) = [APA_v01.toNum(d{k,2}), APA_v01.toNum(d{k,3}), ...
                              APA_v01.toNum(d{k,4}), APA_v01.toNum(d{k,5})];
            end
            switch mode
                case 'phi'
                    [pmin, pmax] = APA_v01.leftoverPhiSpan(rects(:,3:4));
                    d{n,2} = 0;   d{n,3} = 180;
                    d{n,4} = pmin; d{n,5} = pmax;
                case 'theta'
                    [tmin, tmax] = APA_v01.leftoverThetaSpan(rects(:,1:2));
                    d{n,4} = 0;   d{n,5} = 360;
                    d{n,2} = tmin; d{n,3} = tmax;
                otherwise  % 'both'
                    box = APA_v01.leftover2DBoxFromRects(rects);
                    d{n,2} = box(1); d{n,3} = box(2);
                    d{n,4} = box(3); d{n,5} = box(4);
            end
            app.Table_Masks.Data = d;
        end

        function masks = readMasksFromTable(app, n)
            d = app.Table_Masks.Data;
            if size(d,1) ~= n
                rebuildMaskTable(app);
                d = app.Table_Masks.Data;
            end
            masks = zeros(n, 4);
            for k = 1:n
                masks(k,:) = [APA_v01.toNum(d{k,2}), APA_v01.toNum(d{k,3}), ...
                              APA_v01.toNum(d{k,4}), APA_v01.toNum(d{k,5})];
            end
            % Last row is always the explicit complement so callers
            % (combinePatterns) get the leftover region exactly.
            masks(n,:) = [NaN NaN NaN NaN];
        end

        function onExportCombined(app)
            if isempty(app.Combined)
                uialert(app.UIFigure,'No combined pattern yet.','Export'); return;
            end
            [f,p] = uiputfile({'*.fz';'*.csv'},'Export combined pattern','combined.fz');
            figure(app.UIFigure); if isequal(f,0); return; end
            out = fullfile(p,f);
            [~,~,ext] = fileparts(out);
            if strcmpi(ext,'.fz')
                io.writePatternFZ(app.Combined.P, out);
            else
                colN = app.Table_DataOut.ColumnName;
                T = array2table(app.Combined.R.table,'VariableNames',colN);
                writetable(T, out);
            end
        end

        % ---------------------------------------------------------------
        %                       LIBRARY HELPERS
        % ---------------------------------------------------------------
        function addToLibrary(app, P, R, name)
            entry = struct('P',P,'R',R,'name',name);
            % Avoid exact duplicate names by suffixing.
            base = name; suffix = 1;
            while any(strcmp(name, app.LibNames))
                suffix = suffix + 1;
                name = sprintf('%s (%d)', base, suffix);
                entry.name = name;
            end
            app.Lib{end+1}      = entry;
            app.LibNames{end+1} = name;
            refreshLibraryTrees(app);
        end

        function refreshLibraryTrees(app)
            % Tab 3 Tree: two-level (pattern -> coverage runs) + imported runs.
            try
                savedCb = app.Tree.CheckedNodesChangedFcn;
                app.Tree.CheckedNodesChangedFcn = '';
                cleaner = onCleanup(@() APA_v01.restoreTreeCb(app, savedCb)); %#ok<NASGU>
                delete(allchild(app.Tree));
                root = uitreenode(app.Tree,'Text','Patterns & coverage runs');
                root.NodeData = struct('type','root');
                toCheck = matlab.ui.container.TreeNode.empty;
                for k = 1:numel(app.LibNames)
                    pn = uitreenode(root,'Text', app.LibNames{k});
                    pn.NodeData = struct('type','pattern','libIdx',k);
                    % Children: coverage runs linked to this pattern.
                    for r = 1:numel(app.CovRuns)
                        rn = app.CovRuns{r};
                        if isnan(rn.patIdx) || rn.patIdx ~= k; continue; end
                        ch = uitreenode(pn,'Text', APA_v01.runShortLabel(rn));
                        ch.NodeData = struct('type','run','runIdx',r);
                        if rn.visible; toCheck(end+1) = ch; end
                    end
                end
                % Imported coverage runs (no pattern).
                anyImported = false;
                imp = [];
                for r = 1:numel(app.CovRuns)
                    if ~isnan(app.CovRuns{r}.patIdx); continue; end
                    if ~anyImported
                        imp = uitreenode(root,'Text','(Imported coverage)');
                        imp.NodeData = struct('type','imported');
                        anyImported = true;
                    end
                    ch = uitreenode(imp,'Text', app.CovRuns{r}.name);
                    ch.NodeData = struct('type','run','runIdx',r);
                    if app.CovRuns{r}.visible; toCheck(end+1) = ch; end
                end
                expand(app.Tree,'all');
                if ~isempty(toCheck)
                    try; app.Tree.CheckedNodes = toCheck; catch; end
                end
            catch
            end

            % Tab 4 tree stays flat (patterns only, by libIdx).
            try
                delete(allchild(app.Tree2_2));
                root2 = uitreenode(app.Tree2_2,'Text','Patterns in memory');
                root2.NodeData = [];
                for k = 1:numel(app.LibNames)
                    n = uitreenode(root2,'Text', app.LibNames{k});
                    n.NodeData = k;
                end
                expand(app.Tree2_2,'all');
            catch
            end
        end
    end

    % Static helpers
    methods (Static, Access = private)
        function setDropDownSafe(dd, value)
            % Set a uidropdown value without touching the Items list.  If
            % the value doesn't already appear in Items, it is prepended
            % so the assignment always succeeds.
            if ~isgraphics(dd); return; end
            try
                items = dd.Items;
                if ~any(strcmp(items, value))
                    dd.Items = [{value} items];
                end
                dd.Value = value;
            catch
            end
        end

        function v = parseSpinnerOrZero(strOrNum)
            if isnumeric(strOrNum); v = strOrNum; return; end
            if isempty(strOrNum); v = 0; return; end
            v = str2double(strOrNum);
            if isnan(v); v = 0; end
        end

        function s = sanitizeSheet(name, k)
            s = regexprep(name, '[^A-Za-z0-9_\-]', '_');
            if isempty(s); s = sprintf('p%d', k); end
            if numel(s) > 28; s = s(1:28); end
            s = sprintf('%s_%d', s, k);
        end

        function [eCut, hCut, eVal, hVal] = ehPlanes(R, boresightAxis)
            % EHPLANES Resolve the E-Plane and H-Plane principal cuts for
            % a processed pattern R, given the dominant boresight axis
            % (one of '+X','-X','+Y','-Y','+Z','-Z').
            %
            % Output convention (matches plt.getCut):
            %   'Phi Cut'   - FIX theta = val, SWEEP phi.  This is a
            %                 circle of latitude (a great circle only
            %                 when val == 90 deg, i.e. the equator).
            %   'Theta Cut' - FIX phi   = val, SWEEP theta. This is a
            %                 meridian / great circle through the poles.
            %
            % Geometric identification of E vs H:
            %   At the peak direction, the unit vector theta_hat is
            %   tangent to the meridian (along increasing theta), and
            %   phi_hat is perpendicular to it (along increasing phi).
            %     |E_theta| > |E_phi|  =>  E aligned with meridian
            %                              => E-Plane = meridian.
            %     |E_phi|   > |E_theta|=>  E perpendicular to meridian
            %                              => E-Plane = the other plane
            %                                 (perpendicular great circle).
            %
            % Principal great-circle pair per boresight axis:
            %   +-Z  : two orthogonal meridians (Theta Cut at phi=phiM
            %          and Theta Cut at phi=phiM+90).
            %   +-X  : meridian at phi=0/180 (xz-plane) AND equator
            %          (Phi Cut at theta=90, the xy-plane).
            %   +-Y  : meridian at phi=90/270 (yz-plane) AND equator
            %          (Phi Cut at theta=90).

            eCut = 'Theta Cut'; hCut = 'Phi Cut';
            eVal = 0;            hVal = 90;
            if isempty(R) || ~isfield(R,'maxGain_dir'); return; end
            if nargin < 2 || isempty(boresightAxis); boresightAxis = '+Z'; end

            % ---- Peak direction (theta, phi) is used ONLY to sample
            % which E-component dominates; the cut PLANES themselves
            % are determined by the boresight axis.
            peakTheta = R.maxGain_dir(1);   %#ok<NASGU>
            peakPhi   = R.maxGain_dir(2);

            try
                % Snap to the nearest grid sample to read |E_theta| and
                % |E_phi| at the peak.
                [~, iThetaPeak] = min(abs(R.theta - R.maxGain_dir(1)));
                [~, iPhiPeak]   = min(abs(R.phi   - R.maxGain_dir(2)));
                ethMagAtPeak = abs(R.Eth(iThetaPeak, iPhiPeak));
                ephMagAtPeak = abs(R.Eph(iThetaPeak, iPhiPeak));
            catch
                ethMagAtPeak = 1; ephMagAtPeak = 0;
            end

            % Build the two principal-plane candidates (meridian +
            % perpendicular great circle) for the active boresight axis.
            switch upper(boresightAxis)
                case {'+Z','-Z'}
                    % Boresight along Z - the peak is near the pole and
                    % all meridians pass through it.  Snap the recorded
                    % peak phi to the nearest cardinal (0 or 90 deg) so
                    % we lock onto the standard xz / yz principal planes.
                    phiPrincipal = round(mod(peakPhi, 180) / 90) * 90;
                    meridian   = struct('cut','Theta Cut', 'val', mod(phiPrincipal,        360));
                    perpPlane  = struct('cut','Theta Cut', 'val', mod(phiPrincipal + 90,   360));

                case {'+X','-X'}
                    % Boresight along X - peak is on the equator at
                    % phi = 0 or 180.  Principal planes:
                    %   xz-plane = Theta Cut at phi=0 (meridian),
                    %   xy-plane = Phi Cut at theta=90 (equator).
                    phiMeridian = mod(round(peakPhi/180)*180, 360);
                    meridian  = struct('cut','Theta Cut', 'val', phiMeridian);
                    perpPlane = struct('cut','Phi Cut',   'val', 90);

                case {'+Y','-Y'}
                    % Boresight along Y - peak is on the equator at
                    % phi = 90 or 270.  Principal planes:
                    %   yz-plane = Theta Cut at phi=90 (meridian),
                    %   xy-plane = Phi Cut at theta=90 (equator).
                    phiMeridian = mod(round((peakPhi-90)/180)*180 + 90, 360);
                    meridian  = struct('cut','Theta Cut', 'val', phiMeridian);
                    perpPlane = struct('cut','Phi Cut',   'val', 90);

                otherwise
                    % Generic fallback: a meridian through peak phi and
                    % its perpendicular meridian (works for any axis).
                    meridian  = struct('cut','Theta Cut', 'val', mod(peakPhi,    360));
                    perpPlane = struct('cut','Theta Cut', 'val', mod(peakPhi+90, 360));
            end

            % Map E and H onto the two candidates.
            if ethMagAtPeak >= ephMagAtPeak
                ePlane = meridian;  hPlane = perpPlane;
            else
                ePlane = perpPlane; hPlane = meridian;
            end

            eCut = ePlane.cut; eVal = ePlane.val;
            hCut = hPlane.cut; hVal = hPlane.val;
        end

        function method = chooseCombineMethod(app)
            % Legacy fallback (kept for backward compatibility); the
            % primary entry point is now the Tab-4 radio group.
            d = uiconfirm(app.UIFigure, ...
                'Select combination method', 'Combine Patterns', ...
                'Options', {'coherent','incoherent','envelope','masked','Cancel'}, ...
                'DefaultOption', 1, 'CancelOption', 5);
            if strcmp(d,'Cancel'); method = ''; else; method = d; end
        end

        function v = toNum(x)
            % Tolerant cell -> number converter for uitable round-trips.
            if isnumeric(x); v = double(x); return; end
            if iscell(x);    v = APA_v01.toNum(x{1}); return; end
            if ischar(x) || isstring(x)
                v = str2double(x);
                if isnan(v); v = 0; end
                return;
            end
            v = NaN;
        end

        function [pmin, pmax] = leftoverPhiSpan(phiSpans)
            % Given an N-by-2 matrix of [phi_min, phi_max] sectors, return
            % the bounding [pmin, pmax] of the leftover phi range on
            % [0, 360].  For a single contiguous covered region (the
            % typical sector-partition case) this is exact; for
            % non-contiguous covered regions combinePatterns treats the
            % last mask as a NaN-flagged complement so the leftover is
            % handled at evaluation time, not in this bounding box.
            phiSpans = mod(phiSpans, 360);
            covered = false(1, 360);
            for k = 1:size(phiSpans,1)
                a = max(1, min(360, ceil (phiSpans(k,1)+1)));
                b = max(1, min(360, floor(phiSpans(k,2))));
                if a <= b; covered(a:b) = true; end
            end
            uncovered = find(~covered);
            if isempty(uncovered)
                pmin = 0; pmax = 360; return;
            end
            pmin = uncovered(1) - 1;
            pmax = uncovered(end);
        end

        function [tmin, tmax] = leftoverThetaSpan(thetaSpans)
            % Residual polar angle on [0, 180] after union of earlier
            % [theta_min, theta_max] bands (1 deg resolution, inclusive).
            covered = false(1, 181);
            for k = 1:size(thetaSpans,1)
                d0 = round(thetaSpans(k,1));
                d1 = round(thetaSpans(k,2));
                if d0 > d1; tmp = d0; d0 = d1; d1 = tmp; end
                d0 = max(0, min(180, d0));
                d1 = max(0, min(180, d1));
                covered((d0+1):(d1+1)) = true;
            end
            uncovered = find(~covered);
            if isempty(uncovered)
                tmin = 0; tmax = 180; return;
            end
            tmin = uncovered(1) - 1;
            tmax = uncovered(end) - 1;
        end

        function b = leftover2DBoxFromRects(rects)
            % Axis-aligned bounding box of the complement of the union of
            % rectangular (theta,phi) sectors on a 1 deg grid.  If the
            % true leftover is non-rectangular, this box may be larger
            % than the complement; combinePatterns still uses the exact
            % complement when the last row is NaN in readMasksFromTable.
            th = 0:180; ph = 0:360;
            [Tg, Pg] = ndgrid(th, ph);
            M = false(size(Tg));
            for k = 1:size(rects,1)
                t1 = rects(k,1); t2 = rects(k,2);
                p1 = rects(k,3); p2 = rects(k,4);
                M = M | ((Tg >= t1) & (Tg <= t2) & (Pg >= p1) & (Pg <= p2));
            end
            comp = ~M;
            if ~any(comp(:))
                b = [0 180 0 360];
                return;
            end
            tt = Tg(comp);
            pp = Pg(comp);
            b = [min(tt) max(tt) min(pp) max(pp)];
        end

        function [thC, phC] = orientationToAngles(val, defT, defP)
            % val from DropDown_covOrientation ItemsData '1'..'8'.
            switch val
                case '1', thC = 90;  phC = 0;     % +X
                case '2', thC = 90;  phC = 180;   % -X
                case '3', thC = 90;  phC = 90;    % +Y
                case '4', thC = 90;  phC = 270;   % -Y
                case '5', thC = 0;   phC = 0;     % +Z
                case '6', thC = 180; phC = 0;     % -Z
                case '7', thC = defT; phC = defP; % arbitrary -> use spinners
                otherwise, thC = defT; phC = defP;
            end
        end

        function restoreTreeCb(app, cb)
            try; app.Tree.CheckedNodesChangedFcn = cb; catch; end
        end

        function s = runShortLabel(run)
            switch lower(string(run.mode))
                case "spherical", s = 'Spherical';
                case "conical"
                    p = run.params;
                    s = sprintf('Conical  \\theta_0=%g\\circ  \\phi_0=%g\\circ  \\alpha=%g\\circ', ...
                                p.coneTheta_deg, p.conePhi_deg, p.coneAlpha_deg);
                case "imported", s = 'Imported';
                otherwise, s = char(run.mode);
            end
        end

        function maybeCheck(tree, node, visible)
            if ~visible; return; end
            try
                current = tree.CheckedNodes;
                tree.CheckedNodes = [current(:).', node];
            catch
            end
        end

        function exportBatchOne(rootDir, P, R, outFmt, savePlots)
            % Auto-export one batch entry.  Creates rootDir/<name>/ and
            % writes an input pattern file + an output CSV (processed).
            if isempty(P) || isempty(R); return; end
            safe = regexprep(P.meta.name, '[^A-Za-z0-9_\-]', '_');
            if isempty(safe); safe = 'pattern'; end
            outDir = fullfile(rootDir, safe);
            if ~isfolder(outDir); mkdir(outDir); end

            % 1) Raw/input pattern in the user-selected format.
            try
                io.writePattern(P, fullfile(outDir, ['input' outFmt]));
            catch MEw
                warning('Batch input export failed for %s: %s', P.meta.name, MEw.message);
            end

            % 2) Processed output table (always written as CSV/TXT/DAT text
            %    so downstream tools can consume it easily, regardless of
            %    the user's chosen raw format).
            try
                ext = lower(outFmt);
                textExts = {'.csv','.txt','.dat'};
                if ~ismember(ext, textExts); ext = '.csv'; end
                colN = {'Theta','Phi','E_Total_dB','E_RCP_dB','E_LCP_dB', ...
                        'E_RCP_Phase','E_LCP_Phase','AR_dB','PLF_dB', ...
                        'Gain_Polarized','EIRP_dBW','PFD_Wm2','E_field_Vm'};
                T = array2table(R.table, 'VariableNames', colN);
                if strcmp(ext,'.csv')
                    writetable(T, fullfile(outDir, ['output' ext]));
                else
                    writetable(T, fullfile(outDir, ['output' ext]), ...
                               'FileType','text','Delimiter','\t');
                end
            catch MEw
                warning('Batch output export failed for %s: %s', P.meta.name, MEw.message);
            end

            % 3) Optionally render + save the main plots.
            if savePlots
                try
                    APA_v01.dumpBatchPlots(outDir, R);
                catch MEw
                    warning('Plot export failed for %s: %s', P.meta.name, MEw.message);
                end
            end
        end

        function dumpBatchPlots(outDir, R)
            % Render a fixed set of plots headlessly and save them as PNG.
            ctrl = struct('Cmin',-40,'Cmax',10,'Cstep',10, ...
                          'Az',135,'El',30,'CutValue',R.maxGain_dir(2), ...
                          'ShowTitles',true,'ShowPeakMarker',false, ...
                          'viewChangedCb',[]);
            comps = {'Total Gain','RHCP Gain','LHCP  Gain','Axial Ratio'};
            tags  = {'total','rhcp','lhcp','ar'};
            fh = figure('Visible','off','Color','w','Position',[100 100 900 600]);
            cu = onCleanup(@() close(fh));
            for c = 1:numel(comps)
                try
                    ax = axes(fh); %#ok<LAXES>
                    plt.plotContour(ax, R, comps{c}, ctrl);
                    exportgraphics(ax, fullfile(outDir, ['contour_' tags{c} '.png']), 'Resolution',150);
                    clf(fh);
                catch
                end
            end
            try
                ax = axes(fh); plt.plot3D(ax, R, 'Total Gain', ctrl);
                exportgraphics(ax, fullfile(outDir, '3d_total.png'), 'Resolution',150);
            catch
            end
        end

        function tf = looksLikeCoverageFile(file)
            % Heuristic: first column monotonic in reasonable dB range
            % (-200..200) AND later columns bounded in [-1, 101] -> coverage.
            tf = false;
            try
                M = readmatrix(file,'FileType','text');
                if isempty(M) || size(M,2) < 2; return; end
                t = M(:,1);
                rest = M(:,2:end);
                if all(diff(t) > 0) && min(t) > -250 && max(t) < 250 && ...
                        all(rest(:) >= -1, 'all') && all(rest(:) <= 101, 'all')
                    tf = true;
                end
            catch
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            colormap(app.UIFigure, 'jet');
            app.UIFigure.Position = [100 100 1161 750];
            app.UIFigure.Name = 'Antenna Pattern Analyzer';
            app.UIFigure.WindowState = 'maximized';

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

            % Create DestinationDropDownLabel
            app.DestinationDropDownLabel = uilabel(app.T1P1_Grid);
            app.DestinationDropDownLabel.HorizontalAlignment = 'right';
            app.DestinationDropDownLabel.Layout.Row = 4;
            app.DestinationDropDownLabel.Layout.Column = 7;
            app.DestinationDropDownLabel.Text = 'Destination θ:';

            % Create DestinationDropDown
            app.DestinationDropDown = uidropdown(app.T1P1_Grid);
            app.DestinationDropDown.Layout.Row = 4;
            app.DestinationDropDown.Layout.Column = 8;

            % Create DestinationDropDown_2Label
            app.DestinationDropDown_2Label = uilabel(app.T1P1_Grid);
            app.DestinationDropDown_2Label.HorizontalAlignment = 'right';
            app.DestinationDropDown_2Label.Layout.Row = 4;
            app.DestinationDropDown_2Label.Layout.Column = 9;
            app.DestinationDropDown_2Label.Text = 'Destination φ:';

            % Create DestinationDropDown_2
            app.DestinationDropDown_2 = uidropdown(app.T1P1_Grid);
            app.DestinationDropDown_2.Layout.Row = 4;
            app.DestinationDropDown_2.Layout.Column = 10;

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
            app.Grid_PlotCtrl.RowHeight = repmat({'fit'},1,12);

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

            % Create CutmodeLabel - lets the user pick between an explicit
            % Phi/Theta cut ("Custom") or the auto-computed E-Plane / H-Plane
            % derived from the detected boresight + dominant polarisation.
            app.CutmodeLabel = uilabel(app.Grid_PlotCtrl);
            app.CutmodeLabel.HorizontalAlignment = 'right';
            app.CutmodeLabel.Layout.Row = 2;
            app.CutmodeLabel.Layout.Column = 1;
            app.CutmodeLabel.Text = 'Cut mode:';

            app.DropDown_CutMode = uidropdown(app.Grid_PlotCtrl);
            app.DropDown_CutMode.Items = {'E-Plane','H-Plane','Custom'};
            app.DropDown_CutMode.Layout.Row = 2;
            app.DropDown_CutMode.Layout.Column = 2;
            app.DropDown_CutMode.Value = 'E-Plane';

            % Create CuttypeDropDownLabel
            app.CuttypeDropDownLabel = uilabel(app.Grid_PlotCtrl);
            app.CuttypeDropDownLabel.HorizontalAlignment = 'right';
            app.CuttypeDropDownLabel.Layout.Row = 3;
            app.CuttypeDropDownLabel.Layout.Column = 1;
            app.CuttypeDropDownLabel.Text = 'Cut type:';

            % Create DropDown_CutType
            app.DropDown_CutType = uidropdown(app.Grid_PlotCtrl);
            app.DropDown_CutType.Items = {'Phi Cut', 'Theta Cut'};
            app.DropDown_CutType.Layout.Row = 3;
            app.DropDown_CutType.Layout.Column = 2;
            app.DropDown_CutType.Value = 'Phi Cut';

            % Create CutvalueLabel
            app.CutvalueLabel = uilabel(app.Grid_PlotCtrl);
            app.CutvalueLabel.HorizontalAlignment = 'right';
            app.CutvalueLabel.Layout.Row = 4;
            app.CutvalueLabel.Layout.Column = 1;
            app.CutvalueLabel.Text = 'Cut value:';

            % Create Input_Cut_Value
            app.Input_Cut_Value = uispinner(app.Grid_PlotCtrl);
            app.Input_Cut_Value.Limits = [0 360];
            app.Input_Cut_Value.Layout.Row = 4;
            app.Input_Cut_Value.Layout.Column = 2;

            % Create ColorbarminLabel
            app.ColorbarminLabel = uilabel(app.Grid_PlotCtrl);
            app.ColorbarminLabel.HorizontalAlignment = 'right';
            app.ColorbarminLabel.Layout.Row = 5;
            app.ColorbarminLabel.Layout.Column = 1;
            app.ColorbarminLabel.Text = 'Colorbar min:';

            % Create Input_Plot_Cmin
            app.Input_Plot_Cmin = uispinner(app.Grid_PlotCtrl);
            app.Input_Plot_Cmin.Layout.Row = 5;
            app.Input_Plot_Cmin.Layout.Column = 2;
            app.Input_Plot_Cmin.Value = -40;

            % Create ColorbarmaxLabel
            app.ColorbarmaxLabel = uilabel(app.Grid_PlotCtrl);
            app.ColorbarmaxLabel.HorizontalAlignment = 'right';
            app.ColorbarmaxLabel.Layout.Row = 6;
            app.ColorbarmaxLabel.Layout.Column = 1;
            app.ColorbarmaxLabel.Text = 'Colorbar max:';

            % Create Input_Plot_Cmax
            app.Input_Plot_Cmax = uispinner(app.Grid_PlotCtrl);
            app.Input_Plot_Cmax.Layout.Row = 6;
            app.Input_Plot_Cmax.Layout.Column = 2;
            app.Input_Plot_Cmax.Value = 10;

            % Create ColorbarstepLabel
            app.ColorbarstepLabel = uilabel(app.Grid_PlotCtrl);
            app.ColorbarstepLabel.HorizontalAlignment = 'right';
            app.ColorbarstepLabel.Layout.Row = 7;
            app.ColorbarstepLabel.Layout.Column = 1;
            app.ColorbarstepLabel.Text = 'Colorbar step:';

            % Create Input_Plot_Cstep
            app.Input_Plot_Cstep = uispinner(app.Grid_PlotCtrl);
            app.Input_Plot_Cstep.Layout.Row = 7;
            app.Input_Plot_Cstep.Layout.Column = 2;
            app.Input_Plot_Cstep.Value = 10;

            % Create DViewAzSpinnerLabel
            app.DViewAzSpinnerLabel = uilabel(app.Grid_PlotCtrl);
            app.DViewAzSpinnerLabel.HorizontalAlignment = 'right';
            app.DViewAzSpinnerLabel.Layout.Row = 8;
            app.DViewAzSpinnerLabel.Layout.Column = 1;
            app.DViewAzSpinnerLabel.Text = '3D View Az:';

            % Create DViewAzSpinner
            app.DViewAzSpinner = uispinner(app.Grid_PlotCtrl);
            app.DViewAzSpinner.Layout.Row = 8;
            app.DViewAzSpinner.Layout.Column = 2;
            app.DViewAzSpinner.Value = 135;

            % Create DviewElSpinnerLabel
            app.DviewElSpinnerLabel = uilabel(app.Grid_PlotCtrl);
            app.DviewElSpinnerLabel.HorizontalAlignment = 'right';
            app.DviewElSpinnerLabel.Layout.Row = 9;
            app.DviewElSpinnerLabel.Layout.Column = 1;
            app.DviewElSpinnerLabel.Text = '3D view El:';

            % Create DviewElSpinner
            app.DviewElSpinner = uispinner(app.Grid_PlotCtrl);
            app.DviewElSpinner.Layout.Row = 9;
            app.DviewElSpinner.Layout.Column = 2;
            app.DviewElSpinner.Value = 30;

            % Create Show Titles checkbox
            app.CB_ShowGrids = uicheckbox(app.Grid_PlotCtrl);
            app.CB_ShowGrids.Text = 'Show grids';
            app.CB_ShowGrids.Layout.Row = 10;
            app.CB_ShowGrids.Layout.Column = [1 2];
            app.CB_ShowGrids.Value = true;

            % Create Show Peak Marker checkbox
            app.CB_ShowPeakMarker = uicheckbox(app.Grid_PlotCtrl);
            app.CB_ShowPeakMarker.Text = 'Show peak marker';
            app.CB_ShowPeakMarker.Layout.Row = 11;
            app.CB_ShowPeakMarker.Layout.Column = [1 2];
            app.CB_ShowPeakMarker.Value = false;

            % Create 3D View preset dropdown
            app.ViewPresetLabel = uilabel(app.Grid_PlotCtrl);
            app.ViewPresetLabel.HorizontalAlignment = 'right';
            app.ViewPresetLabel.Layout.Row = 12;
            app.ViewPresetLabel.Layout.Column = 1;
            app.ViewPresetLabel.Text = '3D view preset:';

            app.DropDown_ViewPreset = uidropdown(app.Grid_PlotCtrl);
            app.DropDown_ViewPreset.Items = {'Custom','+X (front)','-X (back)','+Y (right)','-Y (left)','+Z (top)','-Z (bottom)','Iso'};
            app.DropDown_ViewPreset.Layout.Row = 12;
            app.DropDown_ViewPreset.Layout.Column = 2;
            app.DropDown_ViewPreset.Value = 'Custom';

            % Make the Grid_PlotCtrl tall enough for the new row.
            try
                app.Grid_PlotCtrl.RowHeight = repmat({'fit'},1,12);
            catch; end

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

            % Create Grid_Spherical - two rows: Az/El readout on top,
            % the axes below.  This keeps the rotation indicator outside
            % the plotting area so it never shifts with the 3D view.
            app.Grid_Spherical = uigridlayout(app.Tab3_Spherical);
            app.Grid_Spherical.ColumnWidth = {'1x'};
            app.Grid_Spherical.RowHeight = {18,'1x'};
            app.Grid_Spherical.RowSpacing = 2;
            app.Grid_Spherical.Padding = [2 2 2 2];

            app.Label_AzEl_Spherical = uilabel(app.Grid_Spherical);
            app.Label_AzEl_Spherical.HorizontalAlignment = 'left';
            app.Label_AzEl_Spherical.FontName = 'Consolas';
            app.Label_AzEl_Spherical.FontColor = [0.2 0.2 0.2];
            app.Label_AzEl_Spherical.Interpreter = 'none';
            app.Label_AzEl_Spherical.Text = '';
            app.Label_AzEl_Spherical.Layout.Row = 1;
            app.Label_AzEl_Spherical.Layout.Column = 1;

            % Create Axes_Spherical
            app.Axes_Spherical = uiaxes(app.Grid_Spherical);
            title(app.Axes_Spherical, 'Title')
            xlabel(app.Axes_Spherical, 'X')
            ylabel(app.Axes_Spherical, 'Y')
            zlabel(app.Axes_Spherical, 'Z')
            app.Axes_Spherical.Layout.Row = 2;
            app.Axes_Spherical.Layout.Column = 1;
            colormap(app.Axes_Spherical, 'jet')

            % Create Tab4_3D
            app.Tab4_3D = uitab(app.Tabs_Pattern);
            app.Tab4_3D.Title = '3D Pattern';

            % Create Grid_3D - same layout as Grid_Spherical.
            app.Grid_3D = uigridlayout(app.Tab4_3D);
            app.Grid_3D.ColumnWidth = {'1x'};
            app.Grid_3D.RowHeight = {18,'1x'};
            app.Grid_3D.RowSpacing = 2;
            app.Grid_3D.Padding = [2 2 2 2];

            app.Label_AzEl_3D = uilabel(app.Grid_3D);
            app.Label_AzEl_3D.HorizontalAlignment = 'left';
            app.Label_AzEl_3D.FontName = 'Consolas';
            app.Label_AzEl_3D.FontColor = [0.2 0.2 0.2];
            app.Label_AzEl_3D.Interpreter = 'none';
            app.Label_AzEl_3D.Text = '';
            app.Label_AzEl_3D.Layout.Row = 1;
            app.Label_AzEl_3D.Layout.Column = 1;

            % Create Axes_3D
            app.Axes_3D = uiaxes(app.Grid_3D);
            title(app.Axes_3D, 'Title')
            xlabel(app.Axes_3D, 'X')
            ylabel(app.Axes_3D, 'Y')
            zlabel(app.Axes_3D, 'Z')
            app.Axes_3D.Layout.Row = 2;
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
            app.Grid_Filled.RowHeight = {'1x'};

            % Create Button2
            app.Button2 = uibutton(app.Grid_Cuts, 'state');
            app.Button2.Text = 'HPBW';
            app.Button2.Layout.Row = 1;
            app.Button2.Layout.Column = 2;

            % Create Label_HPBW
            app.Label_HPBW = uilabel(app.Grid_Cuts);
            app.Label_HPBW.Layout.Row = 2;
            app.Label_HPBW.Layout.Column = 2;
            app.Label_HPBW.WordWrap = 'on';
            app.Label_HPBW.Interpreter = 'none';
            app.Label_HPBW.FontName = 'Consolas';
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
            app.DropDown_output.Items = {'Filter Output:'};
            app.DropDown_output.Layout.Row = 3;
            app.DropDown_output.Layout.Column = 3;
            app.DropDown_output.Value = 'Filter Output:';

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
            app.T2P1_Grid.RowHeight = {'1x', '1x', '1x', '1x'};

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

            % Row 4: batch export / pre-check controls.
            lblExp = uilabel(app.T2P1_Grid);
            lblExp.Text = 'Export Format:';
            lblExp.HorizontalAlignment = 'right';
            lblExp.Layout.Row = 4; lblExp.Layout.Column = 1;

            app.DropDown_BatchExportFmt = uidropdown(app.T2P1_Grid);
            app.DropDown_BatchExportFmt.Items = {'.csv','.txt','.dat','.fz','.uan','.ffe','.ffd','.ffs','.mat'};
            app.DropDown_BatchExportFmt.Value = '.csv';
            app.DropDown_BatchExportFmt.Layout.Row = 4;
            app.DropDown_BatchExportFmt.Layout.Column = 2;

            app.CB_BatchSavePlots = uicheckbox(app.T2P1_Grid);
            app.CB_BatchSavePlots.Text = 'Save plots';
            app.CB_BatchSavePlots.Value = false;
            app.CB_BatchSavePlots.Layout.Row = 4;
            app.CB_BatchSavePlots.Layout.Column = [3 4];

            app.CB_BatchGain3dOnly = uicheckbox(app.T2P1_Grid);
            app.CB_BatchGain3dOnly.Text = 'Pre-check *gain3d* only';
            app.CB_BatchGain3dOnly.Value = true;
            app.CB_BatchGain3dOnly.Layout.Row = 4;
            app.CB_BatchGain3dOnly.Layout.Column = [5 7];

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

            % Create batch inspection panel on the right side of the tree.
            app.Panel_BatchInspect = uipanel(app.Tab2_Grid);
            app.Panel_BatchInspect.Title = 'Batch Inspection';
            app.Panel_BatchInspect.Layout.Row    = [2 3];
            app.Panel_BatchInspect.Layout.Column = [2 3];

            app.Grid_BatchInspect = uigridlayout(app.Panel_BatchInspect);
            app.Grid_BatchInspect.ColumnWidth = {'fit', '1x', '1x'};
            app.Grid_BatchInspect.RowHeight   = {'fit', 'fit', '1x'};

            app.Label_BatchInfo = uilabel(app.Grid_BatchInspect);
            app.Label_BatchInfo.Interpreter = 'tex';
            app.Label_BatchInfo.WordWrap    = 'on';
            app.Label_BatchInfo.Text        = 'Select a processed pattern in the tree to inspect.';
            app.Label_BatchInfo.Layout.Row    = 1;
            app.Label_BatchInfo.Layout.Column = [1 3];

            viewLbl = uilabel(app.Grid_BatchInspect);
            viewLbl.Text = 'View:'; viewLbl.HorizontalAlignment = 'right';
            viewLbl.Layout.Row = 2; viewLbl.Layout.Column = 1;
            app.DropDown_BatchView = uidropdown(app.Grid_BatchInspect);
            app.DropDown_BatchView.Items = {'Contour','Circular','Spherical','3D','Filled Polar','Rect Cut','Polar Cut'};
            app.DropDown_BatchView.Value = 'Contour';
            app.DropDown_BatchView.Layout.Row = 2;
            app.DropDown_BatchView.Layout.Column = 2;

            app.DropDown_BatchComp = uidropdown(app.Grid_BatchInspect);
            app.DropDown_BatchComp.Items = {'Total Gain','RHCP Gain','LHCP  Gain','Axial Ratio','Polarized Gain'};
            app.DropDown_BatchComp.Value = 'Total Gain';
            app.DropDown_BatchComp.Layout.Row = 2;
            app.DropDown_BatchComp.Layout.Column = 3;

            app.Axes_BatchInspect = uiaxes(app.Grid_BatchInspect);
            app.Axes_BatchInspect.Layout.Row    = 3;
            app.Axes_BatchInspect.Layout.Column = [1 3];

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
            app.Button_Conical.Position = [11 49 65 22];

            % Create Button_Spherical
            app.Button_Spherical = uiradiobutton(app.ButtonGroup_Coverage);
            app.Button_Spherical.Text = 'Spherical';
            app.Button_Spherical.Position = [11 71 72 22];
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

            % Create Button (repurposed as "Clear")
            app.Button = uibutton(app.T3P1_Grid, 'push');
            app.Button.Layout.Row = 2;
            app.Button.Layout.Column = 8;
            app.Button.Text = 'Clear';
            app.Button.Tooltip = 'Remove checked patterns/coverage runs from the library.';

            % Plot-control widgets for the coverage line chart.
            app.CB_covGrid = uicheckbox(app.T3P1_Grid);
            app.CB_covGrid.Text = 'Grid';
            app.CB_covGrid.Value = true;
            app.CB_covGrid.Layout.Row = 3;
            app.CB_covGrid.Layout.Column = 8;
            app.CB_covGrid.ValueChangedFcn = @(s,e) refreshCoverageDisplay(app);

            app.CB_covLegend = uicheckbox(app.T3P1_Grid);
            app.CB_covLegend.Text = 'Legend';
            app.CB_covLegend.Value = true;
            app.CB_covLegend.Layout.Row = 3;
            app.CB_covLegend.Layout.Column = 9;
            app.CB_covLegend.ValueChangedFcn = @(s,e) refreshCoverageDisplay(app);

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

            % Create Tab2_Grid_2  (Combine tab outer layout)
            app.Tab2_Grid_2 = uigridlayout(app.Tab4_Combine);
            app.Tab2_Grid_2.ColumnWidth = {'1x', '1x', '1x'};
            app.Tab2_Grid_2.RowHeight   = {'fit', '1.5x', '1x'};

            % Create Tab2_Panel1_2  (top control panel)
            app.Tab2_Panel1_2 = uipanel(app.Tab2_Grid_2);
            app.Tab2_Panel1_2.Title = 'Inputs & Parameters';
            app.Tab2_Panel1_2.Layout.Row    = 1;
            app.Tab2_Panel1_2.Layout.Column = [1 3];

            % Top panel grid: row 1 = Load button, row 2 = method radio
            % group (left) + Combine button (right), row 3 = Export.
            app.T2P1_Grid_2 = uigridlayout(app.Tab2_Panel1_2);
            app.T2P1_Grid_2.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.T2P1_Grid_2.RowHeight   = {'fit', 'fit', 'fit'};

            % Create Button_LoadCombine
            app.Button_LoadCombine = uibutton(app.T2P1_Grid_2, 'push');
            app.Button_LoadCombine.Layout.Row    = 1;
            app.Button_LoadCombine.Layout.Column = [1 10];
            app.Button_LoadCombine.Text = 'Load';

            % Create RadioGroup_CombineMethod
            app.RadioGroup_CombineMethod = uibuttongroup(app.T2P1_Grid_2);
            app.RadioGroup_CombineMethod.Title          = 'Combination method';
            app.RadioGroup_CombineMethod.Layout.Row     = [2 3];
            app.RadioGroup_CombineMethod.Layout.Column  = [1 9];
            app.Radio_Coherent   = uiradiobutton(app.RadioGroup_CombineMethod, ...
                'Text','Coherent (sum complex E-fields)', ...
                'Position',[10 70 350 22]);
            app.Radio_Incoherent = uiradiobutton(app.RadioGroup_CombineMethod, ...
                'Text','Incoherent (sum powers)', ...
                'Position',[10 50 350 22]);
            app.Radio_Envelope   = uiradiobutton(app.RadioGroup_CombineMethod, ...
                'Text','Envelope / max-hold (per-direction winner)', ...
                'Position',[10 30 350 22]);
            app.Radio_Masked     = uiradiobutton(app.RadioGroup_CombineMethod, ...
                'Text','Section-based (masking, per-pattern theta/phi sectors)', ...
                'Position',[10 10 420 22]);
            app.Radio_Coherent.Value = true;

            % Create Button_Combine
            app.Button_Combine = uibutton(app.T2P1_Grid_2, 'push');
            app.Button_Combine.Layout.Row    = 2;
            app.Button_Combine.Layout.Column = 10;
            app.Button_Combine.Text = 'Combine Patterns';

            % Create Button_ExportCombined
            app.Button_ExportCombined = uibutton(app.T2P1_Grid_2, 'push');
            app.Button_ExportCombined.Layout.Row    = 3;
            app.Button_ExportCombined.Layout.Column = 10;
            app.Button_ExportCombined.Text = 'Export Combined Pattern';

            % Create Tree2_2  (pattern picker)
            app.Tree2_2 = uitree(app.Tab2_Grid_2, 'checkbox');
            app.Tree2_2.Layout.Row    = [2 3];
            app.Tree2_2.Layout.Column = 1;

            % Create Panel_Masking  (per-pattern mask limits, only shown
            % when "Section-based" is the active radio).
            app.Panel_Masking = uipanel(app.Tab2_Grid_2);
            app.Panel_Masking.Title = 'Per-pattern sector limits (deg)';
            app.Panel_Masking.Layout.Row    = [2 3];
            app.Panel_Masking.Layout.Column = [2 3];
            app.Panel_Masking.Visible = 'off';

            app.Grid_Masking = uigridlayout(app.Panel_Masking);
            app.Grid_Masking.ColumnWidth = {'fit', '1x'};
            app.Grid_Masking.RowHeight   = {'fit', 'fit', '1x'};

            app.Label_MaskingHelp = uilabel(app.Grid_Masking);
            app.Label_MaskingHelp.Layout.Row    = 1;
            app.Label_MaskingHelp.Layout.Column = [1 2];
            app.Label_MaskingHelp.WordWrap      = 'on';
            app.Label_MaskingHelp.Text = ['Each row defines a (theta, phi) sector for the corresponding ', ...
                'pattern.  Edit limits for the first patterns; the LAST row shows the sector ', ...
                'left for that pattern after subtracting the others (Combine still uses an exact ', ...
                'complement of the rectangles).  Choose below whether the automatic last row ', ...
                'tracks leftover along phi (azimuth), theta (polar), or both (2D bounding box).'];

            app.Label_MaskLeftoverMode = uilabel(app.Grid_Masking);
            app.Label_MaskLeftoverMode.Layout.Row    = 2;
            app.Label_MaskLeftoverMode.Layout.Column = 1;
            app.Label_MaskLeftoverMode.Text = 'Auto leftover (last row) on:';

            app.DropDown_MaskLeftoverMode = uidropdown(app.Grid_Masking);
            app.DropDown_MaskLeftoverMode.Layout.Row    = 2;
            app.DropDown_MaskLeftoverMode.Layout.Column = 2;
            app.DropDown_MaskLeftoverMode.Items = {'Phi (azimuth)','Theta (polar)','Both (theta and phi)'};
            app.DropDown_MaskLeftoverMode.ItemsData = {'phi','theta','both'};
            app.DropDown_MaskLeftoverMode.Value = 'phi';

            app.Table_Masks = uitable(app.Grid_Masking);
            app.Table_Masks.Layout.Row    = 3;
            app.Table_Masks.Layout.Column = [1 2];
            app.Table_Masks.ColumnName    = {'Pattern','theta_min','theta_max','phi_min','phi_max'};
            app.Table_Masks.ColumnEditable = [false true true true true];
            app.Table_Masks.ColumnFormat  = {'char','numeric','numeric','numeric','numeric'};
            app.Table_Masks.RowName = {};

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