// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ActivityState {
  List<ActivityEntity> get activities => throw _privateConstructorUsedError;
  ActivityEntity? get activeActivity => throw _privateConstructorUsedError;
  String? get selectedPlotId => throw _privateConstructorUsedError;
  String? get selectedPlotName => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isCompleting => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ActivityStateCopyWith<ActivityState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityStateCopyWith<$Res> {
  factory $ActivityStateCopyWith(
          ActivityState value, $Res Function(ActivityState) then) =
      _$ActivityStateCopyWithImpl<$Res, ActivityState>;
  @useResult
  $Res call(
      {List<ActivityEntity> activities,
      ActivityEntity? activeActivity,
      String? selectedPlotId,
      String? selectedPlotName,
      bool isLoading,
      bool isCompleting,
      String? errorMessage});
}

/// @nodoc
class _$ActivityStateCopyWithImpl<$Res, $Val extends ActivityState>
    implements $ActivityStateCopyWith<$Res> {
  _$ActivityStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
    Object? activeActivity = freezed,
    Object? selectedPlotId = freezed,
    Object? selectedPlotName = freezed,
    Object? isLoading = null,
    Object? isCompleting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      activities: null == activities
          ? _value.activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<ActivityEntity>,
      activeActivity: freezed == activeActivity
          ? _value.activeActivity
          : activeActivity // ignore: cast_nullable_to_non_nullable
              as ActivityEntity?,
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
      isCompleting: null == isCompleting
          ? _value.isCompleting
          : isCompleting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityStateImplCopyWith<$Res>
    implements $ActivityStateCopyWith<$Res> {
  factory _$$ActivityStateImplCopyWith(
          _$ActivityStateImpl value, $Res Function(_$ActivityStateImpl) then) =
      __$$ActivityStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ActivityEntity> activities,
      ActivityEntity? activeActivity,
      String? selectedPlotId,
      String? selectedPlotName,
      bool isLoading,
      bool isCompleting,
      String? errorMessage});
}

/// @nodoc
class __$$ActivityStateImplCopyWithImpl<$Res>
    extends _$ActivityStateCopyWithImpl<$Res, _$ActivityStateImpl>
    implements _$$ActivityStateImplCopyWith<$Res> {
  __$$ActivityStateImplCopyWithImpl(
      _$ActivityStateImpl _value, $Res Function(_$ActivityStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
    Object? activeActivity = freezed,
    Object? selectedPlotId = freezed,
    Object? selectedPlotName = freezed,
    Object? isLoading = null,
    Object? isCompleting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ActivityStateImpl(
      activities: null == activities
          ? _value._activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<ActivityEntity>,
      activeActivity: freezed == activeActivity
          ? _value.activeActivity
          : activeActivity // ignore: cast_nullable_to_non_nullable
              as ActivityEntity?,
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
      isCompleting: null == isCompleting
          ? _value.isCompleting
          : isCompleting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ActivityStateImpl implements _ActivityState {
  const _$ActivityStateImpl(
      {required final List<ActivityEntity> activities,
      required this.activeActivity,
      required this.selectedPlotId,
      required this.selectedPlotName,
      this.isLoading = false,
      this.isCompleting = false,
      this.errorMessage})
      : _activities = activities;

  final List<ActivityEntity> _activities;
  @override
  List<ActivityEntity> get activities {
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activities);
  }

  @override
  final ActivityEntity? activeActivity;
  @override
  final String? selectedPlotId;
  @override
  final String? selectedPlotName;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isCompleting;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ActivityState(activities: $activities, activeActivity: $activeActivity, selectedPlotId: $selectedPlotId, selectedPlotName: $selectedPlotName, isLoading: $isLoading, isCompleting: $isCompleting, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityStateImpl &&
            const DeepCollectionEquality()
                .equals(other._activities, _activities) &&
            (identical(other.activeActivity, activeActivity) ||
                other.activeActivity == activeActivity) &&
            (identical(other.selectedPlotId, selectedPlotId) ||
                other.selectedPlotId == selectedPlotId) &&
            (identical(other.selectedPlotName, selectedPlotName) ||
                other.selectedPlotName == selectedPlotName) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCompleting, isCompleting) ||
                other.isCompleting == isCompleting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_activities),
      activeActivity,
      selectedPlotId,
      selectedPlotName,
      isLoading,
      isCompleting,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityStateImplCopyWith<_$ActivityStateImpl> get copyWith =>
      __$$ActivityStateImplCopyWithImpl<_$ActivityStateImpl>(this, _$identity);
}

abstract class _ActivityState implements ActivityState {
  const factory _ActivityState(
      {required final List<ActivityEntity> activities,
      required final ActivityEntity? activeActivity,
      required final String? selectedPlotId,
      required final String? selectedPlotName,
      final bool isLoading,
      final bool isCompleting,
      final String? errorMessage}) = _$ActivityStateImpl;

  @override
  List<ActivityEntity> get activities;
  @override
  ActivityEntity? get activeActivity;
  @override
  String? get selectedPlotId;
  @override
  String? get selectedPlotName;
  @override
  bool get isLoading;
  @override
  bool get isCompleting;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$ActivityStateImplCopyWith<_$ActivityStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
