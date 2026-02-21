// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScheduleState {
  List<ScheduleEntity> get schedules => throw _privateConstructorUsedError;
  ScheduleType get selectedFilter => throw _privateConstructorUsedError;
  String? get selectedPlotId => throw _privateConstructorUsedError;
  String? get selectedPlotName => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isCreating => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScheduleStateCopyWith<ScheduleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleStateCopyWith<$Res> {
  factory $ScheduleStateCopyWith(
          ScheduleState value, $Res Function(ScheduleState) then) =
      _$ScheduleStateCopyWithImpl<$Res, ScheduleState>;
  @useResult
  $Res call(
      {List<ScheduleEntity> schedules,
      ScheduleType selectedFilter,
      String? selectedPlotId,
      String? selectedPlotName,
      bool isLoading,
      bool isCreating,
      String? errorMessage});
}

/// @nodoc
class _$ScheduleStateCopyWithImpl<$Res, $Val extends ScheduleState>
    implements $ScheduleStateCopyWith<$Res> {
  _$ScheduleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schedules = null,
    Object? selectedFilter = null,
    Object? selectedPlotId = freezed,
    Object? selectedPlotName = freezed,
    Object? isLoading = null,
    Object? isCreating = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      schedules: null == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<ScheduleEntity>,
      selectedFilter: null == selectedFilter
          ? _value.selectedFilter
          : selectedFilter // ignore: cast_nullable_to_non_nullable
              as ScheduleType,
      selectedPlotId: freezed == selectedPlotId
          ? _value.selectedPlotId
          : selectedPlotId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedPlotName: freezed == selectedPlotName
          ? _value.selectedPlotName
          : selectedPlotName // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleStateImplCopyWith<$Res>
    implements $ScheduleStateCopyWith<$Res> {
  factory _$$ScheduleStateImplCopyWith(
          _$ScheduleStateImpl value, $Res Function(_$ScheduleStateImpl) then) =
      __$$ScheduleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ScheduleEntity> schedules,
      ScheduleType selectedFilter,
      String? selectedPlotId,
      String? selectedPlotName,
      bool isLoading,
      bool isCreating,
      String? errorMessage});
}

/// @nodoc
class __$$ScheduleStateImplCopyWithImpl<$Res>
    extends _$ScheduleStateCopyWithImpl<$Res, _$ScheduleStateImpl>
    implements _$$ScheduleStateImplCopyWith<$Res> {
  __$$ScheduleStateImplCopyWithImpl(
      _$ScheduleStateImpl _value, $Res Function(_$ScheduleStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schedules = null,
    Object? selectedFilter = null,
    Object? selectedPlotId = freezed,
    Object? selectedPlotName = freezed,
    Object? isLoading = null,
    Object? isCreating = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ScheduleStateImpl(
      schedules: null == schedules
          ? _value._schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<ScheduleEntity>,
      selectedFilter: null == selectedFilter
          ? _value.selectedFilter
          : selectedFilter // ignore: cast_nullable_to_non_nullable
              as ScheduleType,
      selectedPlotId: freezed == selectedPlotId
          ? _value.selectedPlotId
          : selectedPlotId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedPlotName: freezed == selectedPlotName
          ? _value.selectedPlotName
          : selectedPlotName // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ScheduleStateImpl implements _ScheduleState {
  const _$ScheduleStateImpl(
      {required final List<ScheduleEntity> schedules,
      required this.selectedFilter,
      required this.selectedPlotId,
      required this.selectedPlotName,
      this.isLoading = false,
      this.isCreating = false,
      this.errorMessage})
      : _schedules = schedules;

  final List<ScheduleEntity> _schedules;
  @override
  List<ScheduleEntity> get schedules {
    if (_schedules is EqualUnmodifiableListView) return _schedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedules);
  }

  @override
  final ScheduleType selectedFilter;
  @override
  final String? selectedPlotId;
  @override
  final String? selectedPlotName;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isCreating;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ScheduleState(schedules: $schedules, selectedFilter: $selectedFilter, selectedPlotId: $selectedPlotId, selectedPlotName: $selectedPlotName, isLoading: $isLoading, isCreating: $isCreating, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleStateImpl &&
            const DeepCollectionEquality()
                .equals(other._schedules, _schedules) &&
            (identical(other.selectedFilter, selectedFilter) ||
                other.selectedFilter == selectedFilter) &&
            (identical(other.selectedPlotId, selectedPlotId) ||
                other.selectedPlotId == selectedPlotId) &&
            (identical(other.selectedPlotName, selectedPlotName) ||
                other.selectedPlotName == selectedPlotName) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_schedules),
      selectedFilter,
      selectedPlotId,
      selectedPlotName,
      isLoading,
      isCreating,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleStateImplCopyWith<_$ScheduleStateImpl> get copyWith =>
      __$$ScheduleStateImplCopyWithImpl<_$ScheduleStateImpl>(this, _$identity);
}

abstract class _ScheduleState implements ScheduleState {
  const factory _ScheduleState(
      {required final List<ScheduleEntity> schedules,
      required final ScheduleType selectedFilter,
      required final String? selectedPlotId,
      required final String? selectedPlotName,
      final bool isLoading,
      final bool isCreating,
      final String? errorMessage}) = _$ScheduleStateImpl;

  @override
  List<ScheduleEntity> get schedules;
  @override
  ScheduleType get selectedFilter;
  @override
  String? get selectedPlotId;
  @override
  String? get selectedPlotName;
  @override
  bool get isLoading;
  @override
  bool get isCreating;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$ScheduleStateImplCopyWith<_$ScheduleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
