abstract class UsecaseWithStream<SuccessType,Param> {
  Stream<SuccessType> call(Param param);
}