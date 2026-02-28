// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;

import '../../api/data_sources/remote/ai_data_source_impl.dart' as _i469;
import '../../api/data_sources/remote/periodic_table_data_source_impl.dart'
    as _i268;
import '../../api/dio/dio_module.dart' as _i67;
import '../../api/web_services.dart' as _i1069;
import '../../data/data_sources/remote/ai_data_source.dart' as _i743;
import '../../data/data_sources/remote/periodic_table_data_source.dart'
    as _i852;
import '../../data/repositories/ai_repository_impl.dart' as _i434;
import '../../data/repositories/periodic_table_repository_imp.dart' as _i573;
import '../../domain/repositories/ai_repository.dart' as _i185;
import '../../domain/repositories/periodic_table_repository.dart' as _i32;
import '../../domain/use_cases/chat_bot_use_case.dart' as _i262;
import '../../domain/use_cases/get_periodic_table_use_case.dart' as _i380;
import '../../presentation/chat_bot/cubit/chat_cubit.dart' as _i22;
import '../../presentation/periodic_table/cubit/periodic_table_view_model.dart'
    as _i43;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final getItModule = _$GetItModule();
    gh.singleton<_i361.BaseOptions>(() => getItModule.provideBaseOptions());
    gh.singleton<_i528.PrettyDioLogger>(
      () => getItModule.providePrettyDioLogger(),
    );
    gh.singleton<_i361.Dio>(
      () => getItModule.provideDio(
        gh<_i361.BaseOptions>(),
        gh<_i528.PrettyDioLogger>(),
      ),
    );
    gh.singleton<_i1069.WebServices>(
      () => getItModule.provideWebServices(gh<_i361.Dio>()),
    );
    gh.factory<_i743.AiDataSource>(
      () => _i469.AiDataSourceImpl(webServices: gh<_i1069.WebServices>()),
    );
    gh.factory<_i852.PeriodicTableDataSource>(
      () => _i268.PeriodicTableDataSourceImpl(
        webServices: gh<_i1069.WebServices>(),
      ),
    );
    gh.factory<_i185.AiRepository>(
      () => _i434.AiRepositoryImpl(gh<_i743.AiDataSource>()),
    );
    gh.factory<_i32.PeriodicTableRepository>(
      () =>
          _i573.PeriodicTableRepositoryImp(gh<_i852.PeriodicTableDataSource>()),
    );
    gh.factory<_i380.GetPeriodicTableUseCase>(
      () => _i380.GetPeriodicTableUseCase(gh<_i32.PeriodicTableRepository>()),
    );
    gh.factory<_i262.ChatBotUseCase>(
      () => _i262.ChatBotUseCase(gh<_i185.AiRepository>()),
    );
    gh.factory<_i43.PeriodicTableViewModel>(
      () => _i43.PeriodicTableViewModel(gh<_i380.GetPeriodicTableUseCase>()),
    );
    gh.factory<_i22.ChatCubit>(
      () => _i22.ChatCubit(gh<_i262.ChatBotUseCase>()),
    );
    return this;
  }
}

class _$GetItModule extends _i67.GetItModule {}
