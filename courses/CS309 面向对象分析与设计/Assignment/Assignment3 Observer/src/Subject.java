public interface Subject<T> {
    public void registerObserver(T t);
    public void removeObserver(T t);
    public void notifyObservers();
    public void notifyObservers(char KeyChar);
//    public void measurementsChanged(T t);
}
