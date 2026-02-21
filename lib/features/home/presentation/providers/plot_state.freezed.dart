// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plot_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlotState {
  List<PlotEntity> get plots => throw _privateConstructorUsedError;
  String? get selectedPlotId => throw _privateConstructorUsedError;
  PlotSortOrder get sortOrder => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlotStateCopyWith<PlotState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlotStateCopyWith<$Res> {
  factory $PlotStateCopyWith(PlotState value, $Res Function(PlotState) then) =
      _$PlotStateCopyWithImpl<$Res, PlotState>;
  @useResult
  $Res call(
      {List<PlotEntity> plots,
      String? selectedPlotId,
      PlotSortOrder sortOrder,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$PlotStateCopyWithImpl<$Res, $Val extends PlotState>
    implements $PlotStateCopyWith<$Res> {
  _$PlotStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plots = null,
    Object? selectedPlotId = freezed,
    Object? sortOrder = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      plots: null == plots
          ? _value.plots
          : plots // ignore: cast_nullable_to_non_nullable
              as List<PlotEntity>,
      selectedPlotId: freezed == selectedPlotId
          ? _value.selectedPlotId
          : selectedPlotId // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as PlotSortOrder,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlotStateImplCopyWith<$Res>
    implements $PlotStateCopyWith<$Res> {
  factory _$$PlotStateImplCopyWith(
          _$PlotStateImpl value, $Res Function(_$PlotStateImpl) then) =
      __$$PlotStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PlotEntity> plots,
      String? selectedPlotId,
      PlotSortOrder sortOrder,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$PlotStateImplCopyWithImpl<$Res>
    extends _$PlotStateCopyWithImpl<$Res, _$PlotStateImpl>
    implements _$$PlotStateImplCopyWith<$Res> {
  __$$PlotStateImplCopyWithImpl(
      _$PlotStateImpl _value, $Res Function(_$PlotStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plots = null,
    Object? selectedPlotId = freezed,
    Object? sortOrder = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$PlotStateImpl(
      plots: null == plots
          ? _value._plots
          : plots // ignore: cast_nullable_to_non_nullable
              as List<PlotEntity>,
      selectedPlotId: freezed == selectedPlotId
          ? _value.selectedPlotId
          : selectedPlotId // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as PlotSortOrder,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PlotStateImpl implements _PlotState {
  const _$PlotStateImpl(
      {required final List<PlotEntity> plots,
      required this.selectedPlotId,
      required this.sortOrder,
      this.isLoading = false,
      this.errorMessage})
      : _plots = plots;

  final List<PlotEntity> _plots;
  @override
  List<PlotEntity> get plots {
    if (_plots is EqualUnmodifiableListView) return _plots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_plots);
  }

  @override
  final String? selectedPlotId;
  @override
  final PlotSortOrder sortOrder;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'PlotState(plots: $plots, selectedPlotId: $selectedPlotId, sortOrder: $sortOrder, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlotStateImpl &&
            const DeepCollectionEquality().equals(other._plots, _plots) &&
            (identical(other.selectedPlotId, selectedPlotId) ||
                other.selectedPlotId == selectedPlotId) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_plots),
      selectedPlotId,
      sortOrder,
      isLoading,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlotStateImplCopyWith<_$PlotStateImpl> get copyWith =>
      __$$PlotStateImplCopyWithImpl<_$PlotStateImpl>(this, _$identity);
}

abstract class _PlotState implements PlotState {
  const factory _PlotState(
      {required final List<PlotEntity> plots,
      required final String? selectedPlotId,
      required final PlotSortOrder sortOrder,
      final bool isLoading,
      final String? errorMessage}) = _$PlotStateImpl;

  @override
  List<PlotEntity> get plots;
  @override
  String? get selectedPlotId;
  @override
  PlotSortOrder get sortOrder;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$PlotStateImplCopyWith<_$PlotStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
